require "rb-inotify"

notifier = INotify::Notifier.new
path = "/home/alessio"

notifier.watch(path, :create) do |event|
  puts "#{event.name} created in #{path}"
end

notifier.run
