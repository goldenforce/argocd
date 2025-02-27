#!/bin/bash

### Initialize
scriptsHome=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

### Load common functions
. ${scriptsHome}/common/computeElapsedTime
. ${scriptsHome}/common/configureFolders
. ${scriptsHome}/common/dbQueryExecute
. ${scriptsHome}/common/echoLog
. ${scriptsHome}/common/executeCommandAndCheckError
. ${scriptsHome}/common/getDatabaseSchemaDetails
. ${scriptsHome}/common/getDatabaseSchemaOwnerUsersDetails
. ${scriptsHome}/common/getEdmApplicationPodDetails
. ${scriptsHome}/common/loadSecretsCertificates
. ${scriptsHome}/common/rdsEndpoint

### Load PostgreSQL Database functions
if [ "$DatabaseType" == "postgresql" ]; then
	. ${scriptsHome}/database/postgresql/common/assignAUDITRoleToGC
	. ${scriptsHome}/database/postgresql/common/assignAUDITTriggers
	. ${scriptsHome}/database/postgresql/common/checkDatabaseExists
	. ${scriptsHome}/database/postgresql/common/configurePlatformState
	. ${scriptsHome}/database/postgresql/common/createDatabasePartition
	. ${scriptsHome}/database/postgresql/common/createDatabaseRole
	. ${scriptsHome}/database/postgresql/common/createDatabaseRolePrivileges
	. ${scriptsHome}/database/postgresql/common/createDatabaseSchema
	. ${scriptsHome}/database/postgresql/common/createTablePlatformState
	. ${scriptsHome}/database/postgresql/common/dropDatabaseRole
	. ${scriptsHome}/database/postgresql/common/initializeDatabase
	. ${scriptsHome}/database/postgresql/common/passwordDatabaseUser
	. ${scriptsHome}/database/postgresql/common/realignDatabaseUser
	. ${scriptsHome}/database/postgresql/common/reorgDatabase
	. ${scriptsHome}/database/postgresql/common/updateDatabaseEdmEnvironment
	
	. ${scriptsHome}/database/postgresql/backupDatabase
	. ${scriptsHome}/database/postgresql/createDatabase
	. ${scriptsHome}/database/postgresql/dropDatabase
	. ${scriptsHome}/database/postgresql/restoreDatabase
fi

### Load Oracle Database functions
if [ "$DatabaseType" == "oracle" ]; then
	. ${scriptsHome}/database/oracle/common/assignAUDITRoleToGC
	. ${scriptsHome}/database/oracle/common/assignAUDITTriggers
	. ${scriptsHome}/database/oracle/common/checkDatabaseExists
	. ${scriptsHome}/database/oracle/common/configurePlatformState
	. ${scriptsHome}/database/oracle/common/createDatabasePartition
	. ${scriptsHome}/database/oracle/common/createDatabaseRole
	. ${scriptsHome}/database/oracle/common/createDatabaseRolePrivileges
	. ${scriptsHome}/database/oracle/common/createDatabaseSchema
	. ${scriptsHome}/database/oracle/common/createTablePlatformState
	. ${scriptsHome}/database/oracle/common/dropDatabaseRole
	. ${scriptsHome}/database/oracle/common/initializeDatabase
	. ${scriptsHome}/database/oracle/common/passwordDatabaseUser
	. ${scriptsHome}/database/oracle/common/realignDatabaseUser
	. ${scriptsHome}/database/oracle/common/reorgDatabase
	. ${scriptsHome}/database/oracle/common/updateDatabaseEdmEnvironment
	
	. ${scriptsHome}/database/oracle/backupDatabase
	. ${scriptsHome}/database/oracle/createDatabase
	. ${scriptsHome}/database/oracle/dropDatabase
	. ${scriptsHome}/database/oracle/restoreDatabase
fi


### Load Edm functions
. ${scriptsHome}/edm/checkDatabaseSchemas
. ${scriptsHome}/edm/checkDatabaseSchemasVerify
. ${scriptsHome}/edm/checkUrlAccess
. ${scriptsHome}/edm/configureCustomRoles
. ${scriptsHome}/edm/configureDatabaseReorg
. ${scriptsHome}/edm/configureDomains
. ${scriptsHome}/edm/configureDatabaseSQL
. ${scriptsHome}/edm/configureEdma
. ${scriptsHome}/edm/configureElasticsearchIndex
. ${scriptsHome}/edm/configureKeycloak
. ${scriptsHome}/edm/configureMount
. ${scriptsHome}/edm/createDatabaseSchemas
. ${scriptsHome}/edm/edmApplication
. ${scriptsHome}/edm/insightApplication
. ${scriptsHome}/edm/instStudioCLI
. ${scriptsHome}/edm/jobsFinalize
. ${scriptsHome}/edm/jobsInitialize
. ${scriptsHome}/edm/restartEDM

if [[ "$edm_version" = *"8.8"* ]]; then
	. ${scriptsHome}/edm/8.8/configureGem
fi
if [[ "$edm_version" = *"8.9"* ]]; then
	. ${scriptsHome}/edm/8.9/configureGem
fi
if [[ "$edm_version" = *"10.0"* ]]; then
	. ${scriptsHome}/edm/10.0/configureGem
fi

### Load Bucket functions
. ${scriptsHome}/bucket/bucket

### Load Job Utilities
. ${scriptsHome}/jobutilities/authTypCheck
. ${scriptsHome}/jobutilities/checkApplicationReachability
. ${scriptsHome}/jobutilities/envTypCheck
. ${scriptsHome}/jobutilities/execWkf
. ${scriptsHome}/jobutilities/getAccessToken
. ${scriptsHome}/jobutilities/getEvent
. ${scriptsHome}/jobutilities/identifierCheck
. ${scriptsHome}/jobutilities/initialize
. ${scriptsHome}/jobutilities/paramCheck
. ${scriptsHome}/jobutilities/responseCodeCheck
. ${scriptsHome}/jobutilities/setTargetApplicationURL
. ${scriptsHome}/jobutilities/spinner
. ${scriptsHome}/jobutilities/wkfStatusCheck

### Load Secrets/Certificates
loadSecretsCertificates

### Configure Folders
configureFolders
