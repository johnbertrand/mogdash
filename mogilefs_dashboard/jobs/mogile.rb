require 'socket'
host =  'localhost'
port =  '9001'
socket = TCPSocket.open(host,port)
uptime = -1
instance_id="fs1"
uptime_interval='1s'
query_interval='1s'

stats = {}
points = []
(1..10).each do |i|
  points << { x: i, y: 0 }
end


last_x = points.last[:x]
last_y=0


# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every interval, :first_in => 0 do |job|
  socket.puts "!stats"
  socket.recv(1024).split( /\r?\n/ ).each do |line|
     stats[line.split[0]] = line.split[1]
  end
 
  last_x += 1
  
  points.shift
  #The differnce between the last sample and now
  points << { x: last_x, y:  stats['queries'].to_i -  last_y  }
  last_y =  stats['queries'].to_i
  
  send_event('uptime',   { fs1uptime: Time.at(stats['uptime'].to_i).utc.strftime("%H:%M:%S") })
  #send_event('queries',  { points: points, queriesnow: stats['queries'], title: "Queries Per Second" })
end

SCHEDULER.every query_interval, :first_in => 0 do |job|
  socket.puts "!stats"
  socket.recv(1024).split( /\r?\n/ ).each do |line|
     stats[line.split[0]] = line.split[1]
  end
 
  last_x += 1
  
  points.shift
  #The differnce between the last sample and now
  points << { x: last_x, y:  stats['queries'].to_i -  last_y  }
  last_y =  stats['queries'].to_i
  
  #send_event('uptime',   { fs1uptime: Time.at(stats['uptime'].to_i).utc.strftime("%H:%M:%S") })
  send_event('queries',  { points: points, queriesnow: stats['queries'], title: "Queries Per Second" })
end

