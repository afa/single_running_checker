require "sys/proctable"
module SingleRunningChecker
  def task_running?(task_name, only_check=false)
    pid_file = File.join(Rails.root, "tmp", "pids", task_name+".pid")
    if File.exists? pid_file
      pid = File.read(pid_file)
      if pid
        proc = Sys::ProcTable.ps(pid.to_i)
        if proc && proc.cmdline =~ /#{task_name}/
          puts "process with pid #{pid} already runinng"
          return true
        end
      end
    end
    open(pid_file, 'w') { |f| f << Process.pid.to_s } unless only_check
    return false
  end
end
