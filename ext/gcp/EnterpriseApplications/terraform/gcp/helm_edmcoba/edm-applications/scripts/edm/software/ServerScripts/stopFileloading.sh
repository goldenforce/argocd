#!/bin/bash
if [ -z "$1" ]
then
	printf "%95s\n" |tr " " "-"
fi
externalProperties=""
scriptFile=`realpath $0`
scriptsHome=`dirname $scriptFile`
. $scriptsHome/startStopFileloading.properties "stop"
serverName=Fileloading
printf "${1}%-8s - %-15s %-6s\n" "Stopping" ${serverName} "Server"

startTime=$( date +%s.%N )

##### Export Details
export JBOSS_HOME=${Jboss_Home}
export JAVA_HOME="${Java_Home}"

jbossConnect="${Jboss_Home}/bin/jboss-cli.sh controller=${Host}:${Server_CLiPort} --commands=connect"
connectStatus=`$jbossConnect`
if [ -z "$connectStatus" ]; then
	jbossConnect="${Jboss_Home}/bin/jboss-cli.sh controller=${Host}:${Server_CLiPort} --connect --command=:read-attribute(name=server-state)"
	connectStatus=`$jbossConnect`
	jbossRunning=$(echo $connectStatus | grep 'success' | grep -v grep | wc -l)
	if [ $jbossRunning -gt 0 ]; then
		${Jboss_Home}/bin/jboss-cli.sh controller=${Host}:${Server_CLiPort} --connect --commands=:"shutdown(timeout=120)" > /dev/null
	fi
fi

##### Kill pending processes
for pid in $(ps -ef | grep java | grep "${Jboss_Home}" | grep offset=${Server_SocketBindingPort} | grep -v grep | awk '{print $2}'); 
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
