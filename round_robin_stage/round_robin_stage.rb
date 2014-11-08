require File.join(File.dirname(__FILE__), '../battle_stage')

SYSTEM_SIZE = 50
NUM_CHASERS = 5
NUM_ESCAPEES = 10
MAX_TIMESTEP = 1000
NUM_RUNS = 10

chaser_strategies = Dir.glob(File.join(File.dirname(__FILE__),"chaser_strategies/*.rb"))
escapee_strategies = Dir.glob(File.join(File.dirname(__FILE__),"escapee_strategies/*.rb"))

results = {}

chaser_strategies.each_with_index do |chaser,ci|
  results[chaser] = {}
  escapee_strategies.each_with_index do |escapee,ei|
    $stderr.puts "Progress: #{ci*escapee_strategies.size+ei+1}/#{chaser_strategies.size*escapee_strategies.size}"
    $stderr.puts "#{File.basename(chaser,'.rb')} v.s. #{File.basename(escapee,'.rb')}"
    results[chaser][escapee] = (1..NUM_RUNS).map do |i|
      $stderr.puts "  round #{i}"
      srand(i)
      load chaser
      load escapee
      stage = BattleStage.new(SYSTEM_SIZE, SYSTEM_SIZE, 5, 10)
      stage.update until stage.finished? or stage.timestep >= MAX_TIMESTEP
      $stderr.puts "    result: #{stage.timestep}"
      stage.timestep
    end
  end
end

# pp results  
$stdout.puts ''

io = File.open("results.csv", 'w')
io.puts (['']+escapee_strategies).map {|escapee| File.basename(escapee,'.rb') }.join(', ')
chaser_strategies.each do |chaser|
  io.print File.basename(chaser,'.rb') + ', '
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
  [File.basename(chaser,'.rb'), ave]
end
averages.sort_by {|a| a[1] }.map {|a| a.join(":\t") }.each {|s| puts s}

$stdout.puts '', "Best escapees"
averages = escapee_strategies.map do |escapee|
  ave = chaser_strategies.map do |chaser|
    a = results[chaser][escapee]
    a.inject(:+).to_f/a.size
  end.inject(:+).to_f/chaser_strategies.size
  [File.basename(escapee,'.rb'), ave]
end
averages.sort_by {|a| a[1] }.reverse.map {|a| a.join(":\t") }.each {|s| puts s}

