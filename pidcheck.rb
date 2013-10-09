pwd     = File.dirname(__FILE__)
pidname = 'rdog.pid'
pidpath = "#{pwd}/#{pidname}"
pidlist = %x(ps -u $USER)

if File.exists?(pidpath)
    pid = File.read(pidpath)
    reg = Regexp.new(pid)

    puts pidlist
    puts pid

    if reg.match(pidlist)
        puts "Watchdog is running"
    else
        puts "Watchdog is NOT RUNNING but there is a pid file"
        puts "REMOVING PID FILE"
        File.delete(pidpath)
    end
else
    puts "NO PID FILE"
end
