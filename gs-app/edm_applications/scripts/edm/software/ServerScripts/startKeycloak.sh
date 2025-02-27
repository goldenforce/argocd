#!/bin/bash
if [ -z "$1" ]
then
	printf "%95s\n" |tr " " "-"
fi
externalProperties=""
scriptFile=`realpath $0`
scriptsHome=`dirname $scriptFile`
serverName=Keycloak

## Server User/Password
export KEYCLOAK_ADMIN=server
export KEYCLOAK_ADMIN_PASSWORD=server@123

## Load secrets
if [ ! -z "${edm_applications_secret_scripts}" ]; then
	export $( cat ${edm_applications_secret_scripts} | xargs )
fi
## Load custom secrets
if [ ! -z "${edm_applications_secret_custom_scripts}" ]; then
	export $( cat ${edm_applications_secret_custom_scripts} | xargs )
fi

. $scriptsHome/startStop${serverName}.properties "start"
. $scriptsHome/Keycloak.properties

printf "${1}%-8s - %-15s %-6s\n" "Starting" ${serverName} "Server"

startTime=$( date +%s.%N )
serverLog=${Application_Logs}/server.log
serverLogDir=`dirname $serverLog`
mkdir -p $serverLogDir
mkdir -p $serverLogDir/tmp

sleepMaxTime=30
Java_Opts=${JAVA_OPTS}

##### Export Details
export JAVA_HOME="${Java_Home}"
export JBOSS_HOME="${Jboss_Home}"
export JAVA_OPTS="${JAVA_ARGS}"

##### Check Database type
dbType="oracle"
if [ "${Target_Database}" == "PostgreSQL" ]; then
	dbType="postgres"
fi

##### Check if Server running
logPatternRunning="${Jboss_Home}"
logPatternStarted="Listening on"
serverNotRunning=$(ps -ef | grep $logPatternRunning | grep -v grep | wc -l)

##### Certificate Details
JVM_Certificate_identityKeyStoreFile=`sed -n 's/.*-DCertificate_identityKeyStoreFile=\([^" ]*\).*/\1/p' $scriptsHome/startStop${serverName}.properties`
Certificate_identityKeyStoreFile=`eval echo ${JVM_Certificate_identityKeyStoreFile}`
JVM_Certificate_identityKeyStorePassphrase=`sed -n 's/.*-DCertificate_identityKeyStorePassphrase=\([^" ]*\).*/\1/p' $scriptsHome/startStop${serverName}.properties`
Certificate_identityKeyStorePassphrase=`eval echo ${JVM_Certificate_identityKeyStorePassphrase}`
JVM_Certificate_trustKeyStoreFile=`sed -n 's/.*-DCertificate_trustKeyStoreFile=\([^" ]*\).*/\1/p' $scriptsHome/startStop${serverName}.properties`
Certificate_trustKeyStoreFile=`eval echo ${JVM_Certificate_trustKeyStoreFile}`
JVM_Certificate_trustKeyStorePassphrase=`sed -n 's/.*-DCertificate_trustKeyStorePassphrase=\([^" ]*\).*/\1/p' $scriptsHome/startStop${serverName}.properties`
Certificate_trustKeyStorePassphrase=`eval echo ${JVM_Certificate_trustKeyStorePassphrase}`

##### Daatabase SSL
JVM_Certificate_databaseClient=`sed -n 's/.*-DCertificate_databaseClient=\([^" ]*\).*/\1/p' $scriptsHome/startStop${serverName}.properties`
Certificate_databaseClient=`eval echo ${JVM_Certificate_databaseClient}`
JVM_Certificate_databaseServer=`sed -n 's/.*-DCertificate_databaseServer=\([^" ]*\).*/\1/p' $scriptsHome/startStop${serverName}.properties`
Certificate_databaseServer=`eval echo ${JVM_Certificate_databaseServer}`
JVM_Certificate_databaseKey=`sed -n 's/.*-DCertificate_databaseKey=\([^" ]*\).*/\1/p' $scriptsHome/startStop${serverName}.properties`
Certificate_databaseKey=`eval echo ${JVM_Certificate_databaseKey}`

##### Database Url
databaseUrl="jdbc:postgresql://${DatabaseHost_Schema_KEYCLOAK}:${DatabasePort_Schema_KEYCLOAK}/${DatabaseService_Schema_KEYCLOAK}?ssl\=true&sslmode\=require&sslcert\=${Certificate_databaseClient}&sslkey\=${Certificate_databaseKey}&sslrootcert\=${Certificate_databaseServer}"
databaseUrl=$(echo $databaseUrl | sed -e 's/\\//g')

sleepInitTime=0
sleepMaxTime=120
status="Started"
if [ $serverNotRunning -lt 1 ]; then
	shortDate=$(date +"%Y%m%d%H%M")
	if test -f "$serverLog"; then
 		mv $serverLog $serverLog.$shortDate
 	fi		 
	touch $serverLog
	nohup ${Jboss_Home}/bin/kc.sh -v start \
		--https-port=${Keycloak_HttpPort} \
		--db=${dbType} \
		--db-username=${SchemaUser_KEYCLOAK} \
		--db-password=${SchemaPassword_KEYCLOAK} \
		--db-url="${databaseUrl}" \
		--http-relative-path="/auth" \
		--https-key-store-file=${Certificate_Home}/${Certificate_identityKeyStoreFile} \
		--https-key-store-password="${Certificate_identityKeyStorePassphrase}" \
		--https-key-store-type=JKS \
		--https-trust-store-file=${Certificate_Home}/${Certificate_trustKeyStoreFile} \
		--https-trust-store-password="${Certificate_trustKeyStorePassphrase}" \
		--https-trust-store-type=JKS \
		--hostname-strict=false \
		--spi-theme-default=GoldenSource \
		--spi-theme-static-max-age=-1 \
		--spi-theme-cache-themes=false \
		--spi-theme-cache-templates=false \
		--spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true \
		--spi-login-protocol-openid-connect-suppress-logout-confirmation-screen=true \
		--proxy=reencrypt \
		--cache=local \
		> ${serverLog} 2>${serverLog} &
	while true;
	do 
		serverConnect=`grep "$logPatternStarted" $serverLog | wc -l`
		if [ $serverConnect -gt 0 ]; then
			break
		fi
		if [ $sleepInitTime -gt $sleepMaxTime ]; then
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
