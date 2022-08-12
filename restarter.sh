#!/bin/bash

# Variables/Constants
LOG_FILE_CLEARED_LAST_IN_SEC=$(date +%s)
LOG_FILE="$(pwd)/restarter.log"
LOG_FILE_CLEAR_FREQ_IN_SEC=86400
CHECK_FREQUENCY_IN_SEC=300
FAILURE_TOLERANCE_IN_SEC=5
SLEEP_AFTER_REBOOT_IN_SEC=450

HOST='#####'
USERNAME='#####'
PASSWORD='#####'

# echo -n "HOST: "; read HOST
# echo -n "USERNAME: "; read USERNAME
# echo -n "PASSWORD: "; read -s PASSWORD

# checkConnection checks to see if internet connection exists.
function checkConnection() {
    log "Checking connection..."
    ping -c 2 10.90.0.1 &> /dev/null
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    return 0
}

function log() {
    # Check to see if the log file needs to be cleared:
    local cur_time=$(date +%s)
    local elapsed=$(($cur_time-$LOG_FILE_CLEARED_LAST_IN_SEC))
    if [ ${elapsed} -gt ${LOG_FILE_CLEAR_FREQ_IN_SEC} ]; then
        echo > ${LOG_FILE}
        # Update last cleared:
        LOG_FILE_CLEARED_LAST_IN_SEC=$(date +%s)
    fi
    # Append the log entry:
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> ${LOG_FILE}
}

function afterRebootCallback() {
    # Check if there is connection:
    checkConnection
    if [ $? -eq 0 ]; then
        log "Router reboot completed successfully, and connection is restored!"
    else
        log "Connection is still down after a reboot.."
    fi
}

# rebootRouter to restore connection.
function rebootRouter() {
    log "Restarting network manager..."
    service network-manager restart
    sleep 5s
    log "Rebooting router..."
    eval "{ sleep 2; echo ${USERNAME}; sleep 3; echo ${PASSWORD}; sleep 3; echo 'dev reboot'; sleep 5; }" | telnet ${HOST}
    log "Reboot completed successfully!"
}

# Main loop:
echo -e "\nRouter controller is listening..."

while true
do
    # Check if there is connection:
    checkConnection
    if [ $? -ne 0 ]; then
        # If the connection is lost for a period of time,
        for ((i=1;i<=FAILURE_TOLERANCE_IN_SEC;i++))
        do
            sleep 1s
            # Check if the connection is restored:
            checkConnection
            if [ $? -eq 0 ]; then
                log "Connection is restored."
                break;
            fi

            # If we reached the limit of the failure tolerance:
            if [ $i -eq ${FAILURE_TOLERANCE_IN_SEC} ]; then
                # Perform reboot
                rebootRouter > /dev/null 2>&1

                sleep ${SLEEP_AFTER_REBOOT_IN_SEC}s
                afterRebootCallback
                break;
            fi
        done
    else
        log "Connection successful."
    fi

    # Sleep until the next check cycle.
    log "Sleeping..."
    sleep ${CHECK_FREQUENCY_IN_SEC}s
done