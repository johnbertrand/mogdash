require 'socket'

class Tracker
  #MogileFS Command
  @@cmd_stats   = '!stats'
  #MogileFS Keys
  @@key_queries = 'queries'
  @@key_uptime  = 'uptime'

  attr_accessor :common_name
  attr_accessor :last_y
  attr_accessor :last_x

  def initialize(host, port, common_name )
    @host = host
    @port = port
    @common_name = common_name

    @last_x=1
    @last_y=0
    @stats = {}
    @points = []
    (1..10).each do |i|
      @points << { x: i, y: @last_y }
    end
    @last_x = @points.last[:x]

  end

  def open()
    @socket = TCPSocket.open(@host, @port)
  end


  def refresh()
    begin
      @socket.puts @@cmd_stats

      @socket.recv(1024).split( /\r?\n/ ).each do |line|
        @stats[line.split[0]] = line.split[1]
      end

      @last_x += 1
      @points.shift
      @points << { x: @last_x, y:  @stats[@@key_queries].to_i -  @last_y  }
      @last_y =  @stats[@@key_queries].to_i

    rescue Exception => wtf
      #Open the socket again if needed
      STDERR.puts wtf.message
      if (!self.socket.open)
        begin
          self.open()
        rescue Exception => wtf
          STDERR.puts "Failed rescuing socket. :( "
          STDERR.puts wtf.message
        end
      end
    end
  end


  def get_queries()
    return @stats[@@key_queries] ||= 0
  end

  def get_uptime()
    return @stats[@@key_uptime] ||= 0
  end

  def get_points()
    return @points
  end


end