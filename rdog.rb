require "rb-inotify"

notifier = INotify::Notifier.new
paths    = ["/home/alessio"]
unwanted = [".gif", ".php"]

paths.each do |path|
    notifier.watch(path, :create, :recursive) do |event|
      unless event.flags.include?(:isdir)
        puts "#{event.name} #{event.flags} in #{path} [#{event.absolute_name}]"
        unwanted.each do |ext|
            if event.name.end_with?(ext)
                puts "ALLERT UNWANTED FILE #{event.name}"
                File.delete(event.absolute_name)
              end
          end
      end
    end
end

status = :running
trap("SIGINT") { status = :exit }
while status == :running do
    if IO.select([notifier.to_io], [], [], 1)
        notifier.process
    end
end

puts "Byez!"
