rails_root  = "/home/rhost/current"

rails_env   = "production"
pid_file    = "#{rails_root}/shared/pids/unicorn.pid"
socket_file = "#{rails_root}/shared/var/unicorn.sock"
log_file    = "#{rails_root}/log/unicorn.log"
error_file  = "#{rails_root}/log/error.log"
username    = "rhost"
group       = "www-data"
old_pid     = pid_file + ".oldbin"

working_directory rails_root
pid pid_file
stderr_path error_file
stdout_path log_file
worker_processes 10

preload_app true
timeout 30

listen socket_file, :backlog => 2048

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
  worker.user(username, group) if Process.euid == 0 && rails_env == "production"
end

