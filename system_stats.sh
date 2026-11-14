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
UPTIME=$(uptime -p)

echo -e "${BOLD}Raportti luotu:${RESET}          $FIN_TIME"
echo -e "${BOLD}Aikavyöhyke:${RESET}    $TZ_NAME $TZ_OFFSET"
echo -e "${BOLD}Käynnissä:${RESET}               $UPTIME"
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

echo -e "${BOLD}Levytila (/):${RESET}"
echo -e "  Käytetty:   ${DISK_RAW}% ($(disk_status "$DISK_RAW"))"
echo -e "  Vapaana:    ${DISK_AVAIL} / Yhteensä: ${DISK_TOTAL}"
echo -e "---------------------------------------------"

# 3. RAM Usage
RAM_STATS=$(free -h | awk '/^Mem:/ {print $2, $3, $7}')
read -r RAM_TOTAL RAM_USED RAM_AVAIL <<< "$RAM_STATS"
RAM_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($3 / $2) * 100}')
echo -e "${BOLD}Keskusmuisti (RAM):${RESET}"
echo -e "  Käytössä:   $RAM_USED ($RAM_PCT%)"
echo -e "  Käytettävissä: $RAM_AVAIL / Yhteensä: $RAM_TOTAL"

echo -e "\n${BOLD}${CYAN}=============================================${RESET}"