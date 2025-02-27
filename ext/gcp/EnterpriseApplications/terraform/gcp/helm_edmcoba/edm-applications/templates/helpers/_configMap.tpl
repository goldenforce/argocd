{{/*
Create Config map definitions
*/}}
{{- define "configMap" -}}
{{- $basic := include "basic" . | fromYaml }}
{{- $applications := include "applications" . | fromYaml }}
data:
  ### Load balancer details
  KUBE_EXTERNAL_LB: {{ $.Values.ingresses.ingress.ui.host }}
  
  ### Elasticsearch  
  KUBE_INTERNAL_LB_elastic: elasticsearch-master.{{ .Release.Namespace }}.svc.cluster.local

  ### EDMA  
  KUBE_INTERNAL_LB_edma: edma.{{ .Release.Namespace }}.svc.cluster.local
  
  ### Internal Load balancer details
  {{- range $v := .Values.deployments.edm.applications }}
  KUBE_INTERNAL_LB_{{ lower $v.name }}: {{ printf "%s.%s.svc.cluster.local" ( lower $v.name ) ( $.Release.Namespace ) }}
  {{- end }}

  ### Namespace
  KUBERNETES_NAMESPACE: {{ .Release.Namespace }}

  ### Flowstudio Details
  {{- range $k, $v := .Values.ingresses.ingress }}
  {{- range $aK, $vK := $applications.applications -}}
  {{- if (eq $aK $k) }}
  {{- if $.Values.ingresses.lb.singleLoadBalancer }}
  KUBE_FLOWSTUDIO_LB_{{ lower $k }}: {{ printf "%s:%s" $v.host ( toString $vK.port ) }}
  {{ else }}
  KUBE_FLOWSTUDIO_LB_{{ lower $k }}: {{ printf "%s:443" $v.host }}
  {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
  
  ### Docapi Endpoints
  Docapi_token_endpoint: {{ "https://docapi.thegoldensource-aws.com/auth/realms/docapi/protocol/openid-connect/token" }}
  Docapi_url: {{ "https://docapi.thegoldensource-aws.com/query/" }}
  Docapi_client_id: {{ "Docapi" }}


  ### Home Details
  application_home: {{ $basic.basic.artefacts.pathApplication }}
  logs_home: {{ $basic.basic.artefacts.pathLogs }}
  mount_home: {{ $basic.basic.artefacts.pathMount }}
  scripts_home: {{ $basic.basic.artefacts.pathScripts }}
  configurations_home: {{ $basic.basic.artefacts.pathConfigurations }}
  quantworkbench_home: {{ printf "%s/quantworkbench" $basic.basic.artefacts.pathApplication }}
  protected_home: {{ "/ext/app/protected" }}
  artefacts_home: {{ $basic.basic.artefacts.path }}
  
  ### Insight Details
  Approot_Dir_INSIGHT : {{ printf "/%s/app/insight/ibi/apps" $basic.basic.artefacts.pathMount }}
  Edatemp_Dir_INSIGHT : {{ printf "/%s/logs/UtilityApplications/Insight/webfocuserver" $basic.basic.artefacts.pathMount }}
  Profiles_Dir_INSIGHT : {{ "/ext/app/insight/ibi/profiles" }}

  ### Environment Details
  engine_environment: {{ $.Values.deployments.edm.engine.environment }}
  edm_environment: {{ $.Values.cluster.environment.name | quote  }}
  edm_version: {{ $.Values.deployments.edm.version | quote }}
  edm_dwh: {{ $.Values.deployments.edm.dwh | quote  }}
  edm_applications_secret_scripts: {{ "/etc/edm/secret/edm-applications-secret.env" }}
  edm_cloud: {{ $.Values.common.cloud  | quote }}
  edm_gem: {{ $.Values.jobs.applications.gem.enabled | quote }}
  edm_elasticsearch: {{ $.Values.subCharts.elasticsearch.master.enabled | quote }}
  edm_elasticsearch_index_staging: {{ $.Values.subCharts.elasticsearch.index | quote }}
  edm_default_orchestrator: {{ $basic.basic.defaultOrchestrator }}
  edm_default_orchestrator_lb: {{ $basic.basic.defaultOrchestratorInternalLB }}
  edm_default_orchestrator_port: {{ $basic.basic.defaultOrchestratorPort }}

  ### Jolokia Details
  edm_jolokia: {{ $basic.basic.edm_jolokia | quote }}
    
  ### Database Details
  DatabaseBackup_StorageName: {{ $.Values.database.backup.storage.name | quote  }}  
  DatabaseBackup_StoragePath: {{ $.Values.database.backup.storage.path | quote  }}
  DatabaseRestore_StorageName: {{ $.Values.database.restore.storage.name | quote  }}  
  DatabaseRestore_StoragePath: {{ $.Values.database.restore.storage.path | quote  }}
  DatabaseSSL: {{ $.Values.database.sslMode | quote }}
  DatabaseTablespace: {{ $.Values.database.tableSpace | quote }}
  DatabaseType: {{ $.Values.database.type | quote }}
  
  ### Database Connection Details
  {{- if eq "oracle" $.Values.database.type }}
  database_connection_provider_cb : {{ "oracle" | quote }}
  database_connection_provider : {{ "oracle:thin:@" | quote }}
  database_connection_is : {{ "oracle" | quote }}
  database_connection_driver : {{ "oracle_thin" | quote }}
  database_connection_name_prefix : {{ "OracleSQL" | quote }}
  database_connection_jar : {{ "ojdbc" | quote }}
  database_connection_default_database : {{ "oracle" | quote }}
  LD_LIBRARY_PATH : {{ "/usr/lib/oracle/21/client64/lib" | quote }}
  ORACLE_HOME : {{ "/usr/lib/oracle/21/client64" | quote }}
  TNS_ADMIN : {{ printf "/%s" $basic.basic.artefacts.pathScripts }}
  {{- else }}
  database_connection_provider_cb : {{ "postgresql" | quote }}
  database_connection_provider : {{ "postgresql://" | quote }}
  database_connection_is : {{ "postgres" | quote }}
  database_connection_driver : {{ "postgres-jdbc" | quote }}
  database_connection_name_prefix : {{ "PostgreSQL" | quote }}
  database_connection_jar : {{ "postgres" | quote }}
  database_connection_default_database : {{ "postgres" | quote }}
  LD_LIBRARY_PATH : {{ printf "/usr/pgsql-%s/lib" $.Values.database.version | quote }}
  {{- end }}

  ### Certificate files  
  Certificate_databaseServer: {{ default "" $.Values.certificates.certificateDatabaseServer | quote }}
  Certificate_databaseClient: {{ default "" $.Values.certificates.certificateDatabaseClient | quote }}
  Certificate_databaseKey: {{ default "" $.Values.certificates.certificateDatabaseKey | quote }}
  Certificate_databaseServer_odbcRoot: {{ default "" $.Values.certificates.certificateDatabaseOdbcRoot | quote }}
  Certificate_databaseServer_odbcCertificate: {{ default "" $.Values.certificates.certificateDatabaseOdbcCertificate | quote }}
  Certificate_databaseServer_odbcKey: {{ default "" $.Values.certificates.certificateDatabaseOdbcKey | quote }}
  
  ### Application Home
  HOME: {{ "/ext/app" }}

  ### Date/Time of Execution
  edm_execution_date: {{ now | date "2006-01-02_15-04" }}

  ### Production
  edm_production: {{ $basic.basic.edm_production | quote }}

  ### Log mode
  log_mode: {{ $basic.basic.logMode }}
  log_all_jobs_summary: {{ printf "/%s/logs/Initialize/allJobsSummary.log" $basic.basic.artefacts.pathLogs }}

  ### Partition
  edm_partition: {{ $basic.basic.partition | quote}}

  ### Timezone
  edm_timezone: {{ $basic.basic.timezone }}
  TZ: {{ $basic.basic.timezone }}

  ### Mount Details
  edm_mount: {{ $basic.basic.edm_mount | quote }}
  edm_mount_force_copy: {{ $basic.basic.artefacts.forceCopy | quote }}

  
  ### Roles
  edm_roles: {{ join "," $.Values.deployments.edm.usersRoles.roles }}
  edm_maker_roles: {{ join "," $.Values.deployments.edm.roles.pricing.maker }}
  edm_checker_roles: {{ join "," $.Values.deployments.edm.roles.pricing.checker | quote }}

  ### Load balancer
  edm_load_balancer: {{ $.Values.ingresses.lb.type | quote }}

  ### Database Operations chosen
  database_operation: {{ $basic.basic.databaseOptionChosen | quote}}

  ### Jobs to be enabled
  search_enable: {{ $.Values.jobs.applications.elasticsearchIndex.enabled | quote }}
  gem_enable: {{ $.Values.jobs.applications.gem.enabled | quote }}
  customroles_enabled: {{ $.Values.deployments.edm.roles.enabled | quote }}
  keycloakusersroles_enabled: {{ $.Values.deployments.edm.usersRoles.enabled | quote  }}
  configuredomains_enable: {{ $.Values.jobs.applications.domains.enabled | quote }}
  databasereorg_enable: {{ $.Values.jobs.applications.reorgDatabase.enabled | quote }}
  databasereorg_options: {{ $.Values.jobs.applications.reorgDatabase.execute | quote }}
  
  ### Certificate curl options
  {{- if eq $.Values.certificates.certificateCurl "others" }}
  cerfificate_curl_options: {{ "--insecure" | quote }}
  {{- end }}
  {{- if eq $.Values.certificates.certificateCurl "path" }}
  cerfificate_curl_options: {{ "--capath /ext/app/protected/Certificates/ui" | quote }}
  {{- end }}
  {{- if eq $.Values.certificates.certificateCurl "pathFiles" }}
  cerfificate_curl_options: {{ "--cacert /ext/app/protected/Certificates/ui/*.cer" | quote }}
  {{- end }}
{{- end }}

{{/*
Create Config map (Scripts) definitions
*/}}

{{- define "configMapScripts" -}}
data:
  {{- $files := .Files }}

  {{- range $path, $_ := .Files.Glob "scripts/**" }}
  {{ $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $files.Get (printf "%s" $path) | b64enc | quote }}
  {{ printf "%s_%s" "files" $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $path | b64enc | quote }} 
  {{- end }}

{{- end }}

{{/*
Create Config map (Configurations) definitions
*/}}

{{- define "configMapConfigurations" -}}
data:
  {{- $files := .Files }}

  {{- range $path, $_ := .Files.Glob "configurations/**" }}
  {{ $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $files.Get (printf "%s" $path) | b64enc | quote }}
  {{ printf "%s_%s" "files" $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $path | b64enc | quote }} 
  {{- end }}

{{- end }}

{{/*
Create Config map (Functions) definitions
*/}}

{{- define "configMapFunctions" -}}
data:
  {{- $files := .Files }}

  {{- range $path, $_ := .Files.Glob "functions/**" }}
  {{ $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $files.Get (printf "%s" $path) | b64enc | quote }}
  {{ printf "%s_%s" "files" $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $path | b64enc | quote }} 
  {{- end }}

{{- end }}
