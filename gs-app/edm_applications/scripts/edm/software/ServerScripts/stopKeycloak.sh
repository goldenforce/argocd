#!/bin/bash
if [ -z "$1" ]
then
	printf "%95s\n" |tr " " "-"
fi
externalProperties=""
scriptFile=`realpath $0`
scriptsHome=`dirname $scriptFile`
. $scriptsHome/startStopKeycloak.properties "stop"
serverName=Keycloak
printf "${1}%-8s - %-15s %-6s\n" "Stopping" ${serverName} "Server"

startTime=$( date +%s.%N )

##### Export Details
export JBOSS_HOME=${Jboss_Home}
export JAVA_HOME="${Java_Home}"

for pid in $(ps -ef | grep ${Jboss_Home} | grep -v grep | awk '{print $2}'); 
do 
	kill -15 $pid 
done

elapsedTime=$( date +%s.%N --date="$startTime seconds ago" )
dateTimeExecuted=$(date '+%Y-%m-%d:%H:%M:%S')
printf "${1}%-8s - %-15s %-6s - Date Time: $dateTimeExecuted - Elapsed Time (Secs): %5.2f\n" "Stopped" ${serverName} "Server" $elapsedTime
if [ -z "$1" ]
then
	printf "%95s\n" |tr " " "-"
fi
