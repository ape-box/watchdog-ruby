require "rb-inotify"

notifier = INotify::Notifier.new
paths    = ["/home/alessio/watchdog"]
unwanted = [".gif", ".php"]
moveto   = "/home/alessio/trash"

paths.each do |path|
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

status = :running
Signal.trap("SIGINT") { status = :exit }
while status == :running do
    if IO.select([notifier.to_io], [], [], 1)
        notifier.process
    end
end

puts "Byez!"
