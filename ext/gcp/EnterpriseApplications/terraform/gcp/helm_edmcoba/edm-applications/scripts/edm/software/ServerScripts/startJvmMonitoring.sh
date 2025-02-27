#!/bin/bash
if [ -z "$1" ]
then
	printf "%95s\n" |tr " " "-"
fi
externalProperties=""
scriptFile=`realpath $0`
scriptsHome=`dirname $scriptFile`
serverName=JvmMonitoring
serverClass=JvmMonitoring
clusterName=JvmMonitoring
serverType=standalone

## Load secrets
if [ ! -z "${edm_applications_secret_scripts}" ]; then
	export $( cat ${edm_applications_secret_scripts} | xargs )
fi
## Load custom secrets
if [ ! -z "${edm_applications_secret_custom_scripts}" ]; then
	export $( cat ${edm_applications_secret_custom_scripts} | xargs )
fi

. $scriptsHome/startStop${serverName}.properties "start"

## Create Service account
${Jboss_Home}/bin/add-user.sh -a ${Service_Account_User} ${Service_Account_Password} -g Administrator,ConfigurationManager,ConfigurationViewer,Connect,EventRaiser,InternalRole,TracingViewer,WorkflowDebugger,WorkflowDeveloper,WorkflowManager,administrators,admin,analyst,rest-all,rest-project,users > /dev/null 2> /dev/null

### Create Application Users
users=`env | grep ApplicationUser`
usersRolesFound=""
for user in $users;
do
	user=$(echo "$user" | cut -d "=" -f 2)
	edmUser=${user,,}
	passwordVariable="ApplicationPassword_${edmUser}"
	edmUserPassword="${!passwordVariable}"
	rolesVariable="ApplicationRoles_${edmUser}"
	edmUserRoles="${!rolesVariable}"
	${Jboss_Home}/bin/add-user.sh -a ${edmUser} ${edmUserPassword} -g ${edmUserRoles} > /dev/null
done

## Create Management User
users=`env | grep KEYCLOAK_ADMIN=`
for user in $users;
do
	user=$(echo "$user" | cut -d "=" -f 2)
	adminUser=${user,,}
	passwordVariable="KEYCLOAK_ADMIN_PASSWORD"
	adminUserPassword="${!passwordVariable}"
	${Jboss_Home}/bin/add-user.sh ${adminUser} ${adminUserPassword} > /dev/null
done

printf "${1}%-8s - %-15s %-6s\n" "Starting" ${serverName} "Server"

startTime=$( date +%s.%N )
serverLog=${Application_Logs}/server.log
serverLogDir=`dirname $serverLog`
mkdir -p $serverLogDir
mkdir -p $serverLogDir/tmp
mkdir -p /tmp/$serverClass

Java_Opts=${JAVA_OPTS}

##### Export Details
export JAVA_HOME="${Java_Home}"
export JBOSS_HOME="${Jboss_Home}"
export JAVA_OPTS="${JAVA_ARGS}"
export DISABLE_JDK_SERIAL_FILTER=true
export RUN_CONF=${Jboss_Home}/${clusterName}/configuration/standalone.conf

##### Check if Server running
jbossConnect="${Jboss_Home}/bin/jboss-cli.sh controller=${Host}:${Server_CLiPort} --commands=connect"
connectStatus=`$jbossConnect`
sleepInitTime=0
sleepMaxTime=1800
status="Started"
if [ ! -z "$connectStatus" ]; then
	shortDate=$(date +"%Y%m%d%H%M")
	if test -f "$serverLog"; then
 		mv $serverLog $serverLog.$shortDate
 	fi		 
	touch $serverLog
	nohup ${Jboss_Home}/bin/$serverType.sh -b ${Host} $Java_Opts> /dev/null 2>&1 &
	while true;
	do
		jbossConnect="${Jboss_Home}/bin/jboss-cli.sh controller=${Host}:${Server_CLiPort} --commands=connect"
		connectStatus=`$jbossConnect`
		if [ -z "$connectStatus" ]
		then
			jbossConnect="${Jboss_Home}/bin/jboss-cli.sh controller=${Host}:${Server_CLiPort} --connect --command=:read-attribute(name=server-state)"
			connectStatus=`$jbossConnect`
			jbossRunning=$(echo $connectStatus | grep 'success' | grep -v grep | wc -l)
			if [ $jbossRunning -gt 0 ]
			then
				break
			fi
		fi
		if [ $sleepInitTime -gt $sleepMaxTime ]
		then
			status="Failed "
			break
		fi
		((sleepInitTime += 2))
		sleep 2
	done
fi
elapsedTime=$( date +%s.%N --date="$startTime seconds ago" )
dateTimeExecuted=$(date '+%Y-%m-%d:%H:%M:%S')
printf "${1}%-8s - %-15s %-6s - Date Time: $dateTimeExecuted - Elapsed Time (Secs): %5.2f\n" "${status}" ${serverName} "Server" $elapsedTime
if [ -z "$1" ]
then
	printf "%95s\n" |tr " " "-"
fi
###################################################################################################
### Check CPU/Memory
checkCPUMemory="N"
scriptFileName=`basename "$0"`
sleepProcessTime=10
functionCheckCPUMemory()
{
	argArray=("jboss.server.name=${serverName}")
	if [[ "$Server_Class" == "Orchestrator" ]]
	then
		argArray+=("TPS-1" "TPS-UI" "MSFTranslator")
	fi
	printf "%-20s %-10s  %-10s %-15s  %-10s\n" "DateTime" "Pid" "Cpu(%)" "Memory(Mb)" "Process"
	printf "%-20s %-10s  %-10s %-15s  %-10s\n" "--------" "---" "------" "----------" "-------"
	while true;
	executionTime=$(date '+%Y-%m-%d:%H:%M:%S')
	do
		processesFound=0
		memoryTotal=0
		for i in "${argArray[@]}"
		do
			processArray=`ps -ef | grep "$i" | grep "${Jboss_Home}" | grep -v grep | grep -v standalone.sh | grep -v "$scriptFileName" | awk '{print $2}'`
			for processId in $processArray;
			do
				memory=`ps -p $processId -o pid= -o rss= -o %cpu= | awk '{Total+=$2} END {print Total/1024}'`
				cmdoutput=`ps -p $processId -o pid= -o %cpu=`
				printf "%-20s %-10s  %6.2f     %10.2f       %-15s\n" $executionTime $cmdoutput $memory $i
				processesFound=`expr $processesFound + 1`
				memoryTotal=`echo $memoryTotal + $memory | bc`
			done
		done
		printf "%-20s %-10s  %-10s %-15s  %-10s\n" "-------------------" "---" "------" "----------" "-------"
		printf "%-20s %-10s  %6s     %10.2f       %-15s\n" $executionTime " " " " $memoryTotal " "
		printf "%-20s %-10s  %-10s %-15s  %-10s\n" "-------------------" "---" "------" "----------" "-------"
		if [ $processesFound -eq 0 ]
		then
			break
		fi
		sleep $sleepProcessTime
	done
}
if [[ "$checkCPUMemory" == "Y" ]]
then
	if [ "$sleepInitTime" -gt "0" ]
	then
		dateTimeExecuted=$(date '+%Y%m%d%H%M%S')
		logFile="${Application_Logs}/cpuMemory.log"
		if test -f "${logFile}"; 
		then
	    	mv ${logFile} ${logFile}.${dateTimeExecuted}
		fi
		functionCheckCPUMemory >> ${logFile} &
	fi
fi
