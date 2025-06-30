# debug_timer.gdb
set pagination off
set confirm off
set verbose off
set $count_init = 0
set $count_calibrate = 0
set $count_ticks = 0
set $count_sleep = 0

break timer_init
commands
  set $count_init = $count_init + 1
  continue
end

break timer_calibrate
commands
  set $count_calibrate = $count_calibrate + 1
  continue
end

break timer_ticks
commands
  set $count_ticks = $count_ticks + 1
  continue
end

break timer_sleep
commands
  set $count_sleep = $count_sleep + 1
  continue
end

# Watchpoint: halt when 'ticks' changes
watch ticks

commands
  continue
end

# After alarm_multiple finishes, run:
# (gdb) dump_counts
define dump_counts
  printf "\n=== Timer Function Call Counts ===\n"
  printf "timer_init: %d\n", $count_init
  printf "timer_calibrate: %d\n", $count_calibrate
  printf "timer_ticks: %d\n", $count_ticks
  printf "timer_sleep: %d\n", $count_sleep
end

break thread_exit
commands
    dump_counts
    quit
end
