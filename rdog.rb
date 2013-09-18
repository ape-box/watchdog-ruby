require "rb-inotify"

notifier = INotify::Notifier.new
# Beware not adding too many mirectories,
# i have enabled recursive watching and that's heavy
# please chek on a virtual machine or somewhere safe

# paths    = [
#     "/home/alessio/joomlainstallation1/images",
#     "/home/alessio/joomlainstallation2/images",
#     "/home/alessio/joomlainstallation3/images",
#     "/home/alessio/joomlainstallation4/images",
# ]

paths    = [
    "/home/alessio/watchdog",
]
pwd = File.dirname(__FILE__)
unwanted = [".gif", ".php"]         # List of unwanted extensions
moveto   = "/home/alessio/trash"    # set to nil if you want to delete files instead of moving them for manual inspection
#moveto   = pwd+"/trash"            # or uncomment me to save the unwanted files here
var_run  = "/var/run"               # Change me to a directory you can write, change the same parameter in kill.sh
#var_run  = pwd                     # or uncomment me to save the pid here (remember to update the kill file)
waitfor  = 60                       # wait for other istance to exit, set to nil to exit immediately


# i prefer having only one instance
if File.exists?("#{var_run}/rdog.pid")
    puts "\nI am allready runnig!"
    exit if waitfor.nil?

    puts "Wainting availability"
    ws = Time.now.to_i
    while File.exists?("#{var_run}/rdog.pid")
        wn = Time.now.to_i
        if (wn - ws) >= waitfor
            puts "Too busy, max time reached!"
            exit
        end
    end
end

# Saving PID to file so you can set crontab to call kill.sh to shutdown and relaunch
puts "\nI am #{Process.pid}"
File.open("#{var_run}/rdog.pid", 'w') {|f| f.write(Process.pid)}

a = Time.now.to_f * 1000000
a = a.to_i
paths.each do |path|
    # the :recursive option can be safely removed
    notifier.watch(path, :create, :recursive) do |event|
        unless event.flags.include?(:isdir)
            unwanted.each do |ext|
                if event.name.end_with?(ext)
                    puts "ALLERT UNWANTED FILE #{event.name}"
                    if moveto.is_a? String
                        identifier = Time.now.to_f * 1000000
                        identifier = identifier.to_i.to_s
                        while File.exists?("#{moveto}/#{identifier}.danger")
                            identifier = "#{identifier}-double"
                        end
                        puts "identifier id #{identifier}"
                        File.rename(event.absolute_name, "#{moveto}/#{identifier}.danger")
                        File.open("#{moveto}/#{identifier}.path", 'w') {|f| f.write(event.absolute_name) }
                    else
                        File.delete(event.absolute_name)
                    end
                end
            end
        end
    end
end

b = Time.now.to_f * 1000000
b = b.to_i
puts "Done adding watchers in #{b - a} micro seconds"

status = :running
Signal.trap("SIGINT") { status = :exit }
while status == :running do
    if IO.select([notifier.to_io], [], [], 1)
        notifier.process
    end
end

File.delete("#{var_run}/rdog.pid")
puts "Byez!"
