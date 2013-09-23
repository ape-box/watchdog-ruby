
require "rb-inotify"

# Beware not adding too many mirectories,
# i have enabled recursive watching and that's heavy
# please chek on a virtual machine or somewhere safe

# paths    = [
#     "/home/alessio/joomlainstallation1/images",
#     "/home/alessio/joomlainstallation2/images",
#     "/home/alessio/joomlainstallation3/images",
#     "/home/alessio/joomlainstallation4/images",
# ]

pwd      = File.dirname(__FILE__)
unwanted = [".gif", ".php"]         # List of unwanted extensions
moveto   = "/home/alessio/trash"    # set to nil if you want to delete files instead of moving them for manual inspection
#moveto  = pwd+"/trash"            # or uncomment me to save the unwanted files here
var_run  = "/var/run"               # Change me to a directory you can write, change the same parameter in kill.sh
#var_run = pwd                     # or uncomment me to save the pid here (remember to update the kill file)
waitfor  = 60                       # wait for other istance to exit, set to nil to exit immediately

notifier = INotify::Notifier.new
pid      = 'rdog_logger.pid'

# i prefer having only one instance
if File.exists?("#{var_run}/#{pid}")
    puts "[#{Time.now}] I am allready runnig!"
    exit if waitfor.nil?

    puts "[#{Time.now}] Wainting availability"
    ws = Time.now.to_i
    while File.exists?("#{var_run}/#{pid}")
        wn = Time.now.to_i
        if (wn - ws) >= waitfor
            puts "[#{Time.now}] Too busy, max time reached!"
            exit
        end
    end
end

# Saving PID to file so you can set crontab to call kill.sh to shutdown and relaunch
puts "\n[#{Time.now}] I am #{Process.pid}"
File.open("#{var_run}/#{pid}", 'w') {|f| f.write(Process.pid)}

paths.each do |path|
    notifier.watch(path, :all_events) do |event|
        puts "\n#{event.name} #{event.flags} in #{path} [#{event.absolute_name}]"
    end
end

status = :running
Signal.trap("SIGINT") { status = :exit }
while status == :running do
    if IO.select([notifier.to_io], [], [], 1)
        notifier.process
    end
end

File.delete("#{var_run}/#{pid}")
puts "\n[#{Time.now}] Byez!"
