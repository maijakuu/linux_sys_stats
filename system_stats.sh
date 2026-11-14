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

# 1. Date, Time & Timezone (Finnish format)
FIN_TIME=$(LC_TIME=fi_FI.UTF-8 date '+%-d.%-m.%Y klo %H.%M.%S')
TZ_NAME=$(timedatectl show -p Timezone --value 2>/dev/null || readlink /etc/localtime | sed 's#.*/zoneinfo/##')
TZ_OFFSET=$(date '+%Z (%z)')
echo -e "${BOLD}Aika:${RESET}          $FIN_TIME"
echo -e "${BOLD}Aikavyöhyke:${RESET}    $TZ_NAME $TZ_OFFSET"
echo -e "---------------------------------------------"

# 2. Root Disk Usage (%)
DISK_RAW=$(df --output=pcent / 2>/dev/null | tail -n 1 | tr -dc '0-9')
DISK_TOTAL=$(df -h --output=size / 2>/dev/null | tail -n 1 | tr -d ' ')
DISK_AVAIL=$(df -h --output=avail / 2>/dev/null | tail -n 1 | tr -d ' ')
# Colorize disk usage based on threshold
#When doing testing, the thresholds will be changed manually to make sure the logic works
if [ "$DISK_RAW" -ge 90 ]; then
   DISK_COLOR=$RED
elif [ "$DISK_RAW" -ge 75 ]; then
   DISK_COLOR=$YELLOW
else
   DISK_COLOR=$GREEN
fi
echo -e "${BOLD}Levytila (/):${RESET}"
echo -e "  Käytetty:   ${DISK_COLOR}${DISK_RAW}%${RESET}"
echo -e "  Vapaana:    ${DISK_AVAIL} / Yhteensä: ${DISK_TOTAL}"
echo -e "---------------------------------------------"

# 3. RAM Usage
RAM_STATS=$(free -h | awk '/^Mem:/ {print $2, $3, $7}')
read -r RAM_TOTAL RAM_USED RAM_AVAIL <<< "$RAM_STATS"
RAM_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($3 / $2) * 100}')
echo -e "${BOLD}Keskusmuisti (RAM):${RESET}"
echo -e "  Käytössä:   $RAM_USED ($RAM_PCT%)"
echo -e "  Käytettävissä: $RAM_AVAIL / Yhteensä: $RAM_TOTAL"
# Check Swap usage if available
SWAP_USED=$(free -h | awk '/^Swap:/ {print $3}')
SWAP_TOTAL=$(free -h | awk '/^Swap:/ {print $2}')
if [ "$SWAP_TOTAL" != "0B" ] && [ -n "$SWAP_TOTAL" ]; then
   echo -e "  Swap:       $SWAP_USED käytetty / $SWAP_TOTAL"
fi
echo -e "\n${BOLD}${CYAN}=============================================${RESET}"