#!/usr/bin/env bash
# Color codes for clean output
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

#Echo makes new line, -e makes bash interpret \n as new line
echo -e "${BOLD}${CYAN}=== JÄRJESTELMÄN TILA (SYSTEM STATUS) ===${RESET}\n"


FIN_TIME=$(LC_TIME=fi_FI.UTF-8 date '+%-d.%-m.%Y klo %H.%M.%S')
TZ_NAME=$(timedatectl show -p Timezone --value 2>/dev/null || readlink /etc/localtime | sed 's#.*/zoneinfo/##')
TZ_OFFSET=$(date '+%Z (%z)')
UPTIME=$(uptime -p)
DISK_RAW=$(df --output=pcent / | tail -n 1 | tr -dc '0-9')
DISK_AVAIL=$(df -h --output=avail / | tail -n 1 | tr -d ' ')
DISK_TOTAL=$(df -h --output=size / | tail -n 1 | tr -d ' ')

# 1. Date, Time & Timezone (Finnish format)
echo -e "${BOLD}Report generated:${RESET}          $FIN_TIME"
echo -e "${BOLD}Timezone of the server:${RESET}    $TZ_NAME $TZ_OFFSET"
echo -e "${BOLD}Server running time:${RESET}       $UPTIME"
echo "---------------------------------------------"

# 2. Root Disk Usage (%)
disk_status() {
    if [ "$1" -ge 80 ]; then
        printf 'WARNING\n'
    else
        printf 'OK\n'
    fi
}
#TESTS
#disk_status 50  # Expected OK
#disk_status 80  # Expected WARNING
#disk_status 90  # Expected WARNING

echo -e "${BOLD}Diskspace (/):${RESET}"
echo -e "  Used:   ${DISK_RAW}% ($(disk_status "$DISK_RAW"))"
echo -e "  Free:    ${DISK_AVAIL} / Total: ${DISK_TOTAL}"
echo -e "---------------------------------------------"

# 3. RAM Usage
RAM_STATS=$(free -h | awk '/^Mem:/ {print $2, $3, $7}')
read -r RAM_TOTAL RAM_USED RAM_AVAIL <<< "$RAM_STATS"
RAM_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($3 / $2) * 100}')
echo -e "${BOLD}RAM (RAM):${RESET}"
echo -e "  Used:   $RAM_USED ($RAM_PCT%)"
echo -e "  Available: $RAM_AVAIL / Total: $RAM_TOTAL"

echo -e "\n${BOLD}${CYAN}=============================================${RESET}"