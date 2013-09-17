require "rb-inotify"

notifier = INotify::Notifier.new
# Beware not adding too many mirectories,
# i have enabled recursive watching and that's eavy
paths    = [
    "/home/alessio/joomlainstallation1/images",
    "/home/alessio/joomlainstallation2/images",
    "/home/alessio/joomlainstallation3/images",
    "/home/alessio/joomlainstallation4/images",
]
unwanted = [".gif", ".php"]
moveto   = "/home/alessio/trash"

a = Time.now.to_f * 1000000
a = a.to_i
paths.each do |path|
    # the :recursive option can be safely removed
    notifier.watch(path, :create, :recursive) do |event|
        unless event.flags.include?(:isdir)
            puts "#{event.name} #{event.flags} in #{path} [#{event.absolute_name}]"
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

puts "Byez!"
