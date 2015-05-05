mogdash
=======

This is a dashing.io widget that graphs MogileFS queries.  It was my first widget, and I am still learning Ruby, coffee script.  So be warned.  It's a little hacky, but it works, and looks very cool.
Here is how to make it .  
1) copy the jobs/trackers.rb file to your jobs folder

2) copy the widgets/mogile folder to your widgets folder

3) Copy the tracker.rb file to your lib folder

4) Edit the jobs/tracker.rb file.  At the top you will see a trackers array.  Add your trackers there.  The convention is (HOST_NAME, Port, DISPLAY_NAME). Though I don't think DISPLAY_NAME is used right now 

5) Edit the send_events in SCHEDULER loop.  Just append or delete values in the json string as needed.  Right now it's setup for 3 trackers(fs1,fs2,fs3.)  Hacky, I know, I'm sorry.

6)edit the widgets/mogile.coffee script.  In the ready: block edit the series array. Make sure you have the same amount of series as you do trackers.  It's currently set to three, just copy and paste the blocks as needed.  You also need to edit the graph.series array right below adding a @get for each set of data.  Copy/Paste, delete as needed.  You will also need to set the series.data in the onData: event.  Just follow the convention there and it will work.

Please feel free to contact me if you need any help getting this going.  

