require File.join(File.dirname(__FILE__), '../battle_stage')
require 'optparse'

SYSTEM_SIZE = 50
NUM_CHASERS = 5
NUM_ESCAPEES = 10
MAX_TIMESTEP = 1000
NUM_RUNS = 10

str_dir = File.join(File.dirname(__FILE__), "strategies")
opts = OptionParser.new
opts.on("-d STRATEGY_DIR") {|d| str_dir = d }
opts.parse!

Dir.glob(File.join(str_dir, "*.rb")).each {|c| require c}
chaser_strategies = ChaserStrategy.subclasses
escapee_strategies = EscapeeStrategy.subclasses

results = {}

chaser_strategies.each_with_index do |chaser,ci|
  results[chaser] = {}
  escapee_strategies.each_with_index do |escapee,ei|
    $stderr.puts "Progress: #{ci*escapee_strategies.size+ei+1}/#{chaser_strategies.size*escapee_strategies.size}"
    $stderr.puts "#{chaser} v.s. #{escapee}"
    results[chaser][escapee] = (1..NUM_RUNS).map do |i|
      $stderr.puts "  round #{i}"
      srand(i)
      stage = BattleStage.new(SYSTEM_SIZE, SYSTEM_SIZE, 5, 10, chaser, escapee)
      stage.update until stage.finished? or stage.timestep >= MAX_TIMESTEP
      $stderr.puts "    result: #{stage.timestep}"
      $stderr.puts "    num_survivors: #{stage.num_escapees}"
      stage.timestep
    end
  end
end

# pp results  
$stdout.puts ''

io = File.open("results.csv", 'w')
io.puts (['']+escapee_strategies).map {|escapee| escapee.to_s }.join(', ')
chaser_strategies.each do |chaser|
  io.print chaser.to_s + ', '
  s = escapee_strategies.map do |escapee|
    durations = results[chaser][escapee]
    durations.inject(:+).to_f/durations.size
  end
  io.puts s.join(', ')
end

$stdout.puts '', "Best chasers"
averages = chaser_strategies.map do |chaser|
  ave = escapee_strategies.map do |escapee|
    a = results[chaser][escapee]
    a.inject(:+).to_f/a.size
  end.inject(:+).to_f/escapee_strategies.size
  [chaser, ave]
end
averages.sort_by {|a| a[1] }.map {|a| a.join(":\t") }.each {|s| puts s}

$stdout.puts '', "Best escapees"
averages = escapee_strategies.map do |escapee|
  ave = chaser_strategies.map do |chaser|
    a = results[chaser][escapee]
    a.inject(:+).to_f/a.size
  end.inject(:+).to_f/chaser_strategies.size
  [escapee, ave]
end
averages.sort_by {|a| a[1] }.reverse.map {|a| a.join(":\t") }.each {|s| puts s}

