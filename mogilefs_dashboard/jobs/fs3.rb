require 'socket'
host =  'localhost'
port =  '9003'
socket = TCPSocket.open(host,port)
uptime = -1
instance_id="fs3"
uptime_interval='1s'
interval='1s'

stats = {}
points = []
(1..10).each do |i|
  points << { x: i, y: 0 }
end


last_x = points.last[:x]
last_y=0


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


  send_event('fs3',  { points: points, queriesnow: stats['queries'], uptime: Time.at(stats['uptime'].to_i).utc.strftime("%H:%M:%S")})
end