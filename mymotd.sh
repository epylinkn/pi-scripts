#!/usr/bin/env bash
export TERM=xterm-256color

let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`
IP4=`ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
PIMODEL=$(cat /proc/device-tree/model | tr -d '\0')
PIRELEASE=$(cat /etc/os-release | grep PRETTY_NAME | cut -d\" -f2)

# get the load averages
read one five fifteen rest < /proc/loadavg

echo ""
echo "$(tput setaf 2)
                  `date +"%A, %e %B %Y, %r"`
                  ${PIMODEL}
   .~~.   .~~.    ${PIRELEASE}
  '. \ ' ' / .'   `uname -srmo`$(tput setaf 1)
   .~ .~~~..~.
  : .~.'~'.~. :   Uptime.............: ${UPTIME}
 ~ (   ) (   ) ~  Memory.............: `cat /proc/meminfo | grep MemFree | awk {'print $2'}`kB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'print $2'}`kB (Total)
( : '~'.~.'~' : ) Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
 ~ .~ (   ) ~. ~  Running Processes..: `ps ax | wc -l | tr -d " "`
  (  : '~' :  )   IP Address (eth0)..: ${IP4}
   '~ .~~~. ~'    Disk Usage.........: $(df -h  | grep '^/dev/root' | awk '{ print $3 " / " $4 " (" $5 ")"}') on /dev/root
       '~'
$(tput sgr0)"
~
