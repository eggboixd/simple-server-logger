#!/bin/bash

get_cpu_usage(){
  echo "CPU Usage:"
  mpstat 1 1 | awk '/all/ { printf "CPU Usage: %.2f%% used\n", 100 - $12 }'
}

get_memory_usage(){
  echo "Memory Usage:"
  free -m | awk 'NR==2 { printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3, $2, $3*100/$2 }'
}

get_disk_usage(){
  echo "Disk Usage:"
  df -h --total | awk 'END { print "Used: " $3 ", Free: " $4 ", Usage: " $5 }'
}

get_top_cpu_processes(){
  echo "Top 5 Processes by CPU Usage:"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

get_top_mem_processes(){
  echo "Top 5 Processes by Memory Usage:"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
}

get_extra_stats(){
  echo "OS Version:"
  lsb_release -a 2>/dev/null || cat /etc/os-release

  echo "Uptime:"
  uptime

  echo "Load Average:"
  cat /proc/loadavg

  echo "Logged in users:"
  who
}

main(){
  echo "========== Server Performance Stats =========="
  get_cpu_usage
  echo
  get_memory_usage
  echo
  get_disk_usage
  echo
  get_top_cpu_processes
  echo
  get_top_mem_processes
  echo
  get_extra_stats
  echo "=============================================="
}

main
