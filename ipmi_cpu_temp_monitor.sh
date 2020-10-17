#!/bin/bash


#This script can be deployed as a cron job.
#If the CPU temperature status is not ok, then the script will keep checking the
#CPU temperature status "MAX_NO_OF_INTERVALS" times in "TIME_OF_INTERVAL" minutes
#until the next cron job run or until the CPU temperature status is ok.
#Thus "TIME_OF_INTERVAL" * "MAX_NO_OF_INTERVALS" + "TIME_OF_INTERVAL" should be
#the time intervals between each cron job run.
#Here the time interval between each cron job is 30 mnutes


COUNT=1
MAX_NO_OF_INTERVALS=5
TIME_OF_INTERVAL=5
EMAIL_ID=your_email_address_here

while [[ $(ipmitool sdr entity 3 | grep -i temp | awk '$6 != "ok"') ]]
do

        echo "System Temperature Alert" > TempNotOK.txt
        echo "Hostname: $(hostname)" >> TempNotOK.txt
        echo "IP ADDRESS: $(hostname -i)" >> TempNotOK.txt
        ipmitool sdr entity 3 >> TempNotOK.txt
        cat TempNotOK.txt | mailx -s 'System Temperature Alert on '$HOSTNAME $EMAIL_ID


        if [ $COUNT -le $MAX_NO_OF_INTERVALS ]
        then
                sleep "$TIME_OF_INTERVAL"m
                COUNT=$(($COUNT+1))

        else
                break
        fi

done
