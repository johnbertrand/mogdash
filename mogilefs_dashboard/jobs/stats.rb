require 'socket'
host = 'localhost'
port = '9001'
socket = TCPSocket.open(host,port)
uptime = -1

stats = {}

points = []
(1..10).each do |i|
  points << { x: i, y: 0 }
end
last_x = points.last[:x]

last_y=0


# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1s', :first_in => 0 do |job|
  socket.puts "!stats"
  socket.recv(1024).split( /\r?\n/ ).each do |line|
     stats[line.split[0]] = line.split[1]
  end
  
  points.shift
  last_x += 1
  
   
  #The differnce between the last sample and now
  d =  stats['queries'].to_i -  last_y 

 
  
  points << { x: last_x, y:  d }
  
 
  last_y =  stats['queries'].to_i
  
  
  puts "----end----"
  send_event('uptime',   { uptime: Time.at(stats['uptime'].to_i).utc.strftime("%H:%M:%S") })
  send_event('queries',  { points: points, queriesnow: stats['queries'], title: "Queries Per Second" })
end


