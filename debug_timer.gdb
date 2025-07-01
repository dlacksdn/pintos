# debug_timer.gdb
# GDB Dynamic Analysis Script for Timer Module

set pagination off
set confirm off
set verbose off

# Counter Variables for Original API functions
set $count_init = 0
set $count_calibrate = 0
set $count_ticks = 0
set $count_sleep = 0

# Counter Variables for Additional timer-related functions
set $count_interrupt = 0
set $count_toomany = 0
set $count_busywait = 0
set $count_realtime_sleep = 0
set $count_realtime_delay = 0
set $count_print_stats = 0

# Breakpoints and Counting for Original API functions
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

# Breakpoints and Counting for Additional functions
break timer_interrupt
commands
  set $count_interrupt = $count_interrupt + 1
  continue
end

break too_many_loops
commands
  set $count_toomany = $count_toomany + 1
  continue
end

break busy_wait
commands
  set $count_busywait = $count_busywait + 1
  continue
end

break real_time_sleep
commands
  set $count_realtime_sleep = $count_realtime_sleep + 1
  continue
end

break real_time_delay
commands
  set $count_realtime_delay = $count_realtime_delay + 1
  continue
end

break timer_print_stats
commands
  set $count_print_stats = $count_print_stats + 1
  continue
end

# Watchpoint for ticks variable
watch ticks
commands
  continue
end

# Summary Output Command
define dump_counts
  printf "\n=== Timer Function Call Counts ===\n"
  printf "timer_init: %d\n", $count_init
  printf "timer_calibrate: %d\n", $count_calibrate
  printf "timer_ticks: %d\n", $count_ticks
  printf "timer_sleep: %d\n", $count_sleep
  printf "timer_interrupt: %d\n", $count_interrupt
  printf "too_many_loops: %d\n", $count_toomany
  printf "busy_wait: %d\n", $count_busywait
  printf "real_time_sleep: %d\n", $count_realtime_sleep
  printf "real_time_delay: %d\n", $count_realtime_delay
  printf "timer_print_stats: %d\n", $count_print_stats
end

# Automatic summary at thread_exit
break thread_exit
commands
  dump_counts
  quit
end
