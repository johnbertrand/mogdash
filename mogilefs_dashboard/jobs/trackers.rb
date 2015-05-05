
begin
trackers = Array.new
#add your trackers here
trackers << Tracker.new('fs01.somedomain.com',7001,'fs1')
trackers << Tracker.new('fs02.somedomain.com',7001,'fs2')
trackers << Tracker.new('fs03.somedomain.com',7001,'fs3')

interval ='1s'

all_points = []
(1..10).each do |i|
  all_points << { x: i, y: 0 }
end


trackers.each { |t| t.open }

SCHEDULER.every interval, :first_in => 0 do |job|
  trackers.each { |t| t.refresh
                      send_event(t.common_name ,  { points: t.get_points, queriesnow: t.get_queries, uptime: Time.at(t.get_uptime.to_i).utc.strftime("%H:%M:%S")}) }

  #
  send_event('mogile',  {  fs1: trackers[0].get_points, fs1meta: "FS1: " + trackers[0].get_queries,fs1qps: "FS1: " + trackers[0].last_y.to_s,
                           fs2: trackers[1].get_points, fs2meta: "FS2: " + trackers[1].get_queries,fs2qps: "FS2: " + trackers[1].last_y.to_s,
                           fs3: trackers[2].get_points, fs3meta: "FS3: " + trackers[2].get_queries,fs3qps: "FS3: " + trackers[2].last_y.to_s
                            } )


end
rescue Exception => wtf
  puts wtf.message
end
