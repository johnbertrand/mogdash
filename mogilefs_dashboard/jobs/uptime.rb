require 'socket'
host = 'localhost'
port = '9001'
socket = TCPSocket.open(host,port)
uptime = -1


stats = {}

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1s', :first_in => 0 do |job|
  socket.puts "!stats"
  socket.recv(1024).split( /\r?\n/ ).each do |line|
     stats[line.split[0]] = line.split[1]
  end

  send_event('uptime',   { uptime: Time.at(stats['uptime'].to_i).utc.strftime("%H:%M:%S") })

end

