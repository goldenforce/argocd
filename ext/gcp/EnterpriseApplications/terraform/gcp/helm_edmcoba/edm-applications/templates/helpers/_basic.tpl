{{/*
####################################################
Create the name Environment to be used
*/}}
{{- define "basic" -}}
{{- $applications := include "applications" . | fromYaml }}
basic:
  cloud:
    option: {{ $.Values.common.cloud }}
    {{- if eq $.Values.common.cloud "azure" }}
    ingressTls: true
    ingressTlsHost: true
    ingressExternalDns: {{ $.Values.cluster.externalDns.create }}
    ingressPathSuffix: ""
    hpaApiVersion: autoscaling/v2
    {{- end }}    
    {{- if eq $.Values.common.cloud "aws" }}
    {{- if eq $.Values.ingresses.lb.type "alb" }}
    ingressTls: {{ $.Values.cluster.externalDns.create }}
    ingressTlsHost: {{ $.Values.cluster.externalDns.create }}
    ingressExternalDns: {{ $.Values.cluster.externalDns.create }}
    ingressPathSuffix: "/*"
    hpaApiVersion: autoscaling/v2
    {{- end }}    
    {{- end }}    
    {{- if eq $.Values.common.cloud "aws" }}
    {{- if eq $.Values.ingresses.lb.type "nlb" }}
    ingressTls: true
    ingressTlsHost: true
    ingressExternalDns: {{ $.Values.cluster.externalDns.create }}
    ingressPathSuffix: ""
    hpaApiVersion: autoscaling/v2
    {{- end }}    
    {{- end }}    
    {{- if eq $.Values.common.cloud "gcp" }}
    ingressTls: true
    ingressTlsHost: true
    ingressExternalDns: {{ $.Values.cluster.externalDns.create }}
    ingressPathSuffix: ""
    hpaApiVersion: autoscaling/v2
    {{- end }}    
    {{- if eq $.Values.common.cloud "openshift" }}
    {{- if eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default" }}
    ingressTls: false
    ingressTlsHost: true
    ingressExternalDns: {{ $.Values.cluster.externalDns.create }}
    ingressPathSuffix: ""
    hpaApiVersion: autoscaling/v2
    {{- end }}    
    {{- end }}    
    {{- if eq $.Values.common.cloud "openshift" }}
    {{- if eq $.Values.ingresses.ingress.ui.ingressClassName "nginx" }}
    ingressTls: true
    ingressTlsHost: true
    ingressExternalDns: {{ $.Values.cluster.externalDns.create }}
    ingressPathSuffix: ""
    hpaApiVersion: autoscaling/v2
    {{- end }}    
    {{- end }}    
  environment: {{ $.Values.cluster.environment.name }}
  persistentVolume:
    path: {{ "edmfs" }}
  artefacts:
    path: {{ $.Values.cluster.artefacts.path.application }}
    forceCopy: {{ $.Values.cluster.artefacts.path.forceCopy }}
    {{- if eq $.Values.cluster.artefacts.path.application "local" }}
    pathApplication: {{ "ext/app" }}
    pathScripts: {{ printf "%s/software/ServerScripts" "ext/app" }}
    pathConfigurations: {{ printf "%s/software/ApplicationConfigurations" "ext/app" }}
    pathProtected: {{ printf "%s/Protected" "ext/app" }}
    {{- else }}
    pathApplication: {{ "ext/app" }}
    pathScripts: {{ printf "%s/software/ServerScripts" "ext/app" }}
    pathConfigurations: {{ printf "%s/software/ApplicationConfigurations" "ext/app" }}
    pathProtected: {{ printf "%s/Protected" "ext/app" }}
    {{- end }}
    {{- if eq $.Values.cluster.artefacts.path.logs "local" }}
    pathLogs: {{ "ext/app" }}
    pathMount: {{ "ext/app" }}
    {{- else }}
    pathLogs: {{ printf "%s" "edmfs" }}
    pathMount: {{ printf "%s" "edmfs" }}
    {{- end }}
  cluster:
    serviceAccountName: {{ printf "%s" .Values.cluster.serviceAccount.name }}
    role: {{ printf "%s-cluster-role" .Values.cluster.environment.name }}
    node: 
      {{- with $.Values.deployments.node }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
  imagePullPolicy: {{ $.Values.deployments.edm.images.imagePullPolicy }}
  imagePullSecretsEnabled: {{ $.Values.deployments.edm.images.imagePullSecrets.enabled }}
  imagePullSecretsName: {{ $.Values.deployments.edm.images.imagePullSecrets.name }}
  realm: {{ $.Values.cluster.environment.name }}
  customHelm: {{ $.Values.deployments.edm.customHelm }}

  ### gem
  gemEnabled: {{ $.Values.jobs.applications.gem.enabled }}

  ### Custom JVM Keys
  {{- $customJvmKeysList := list -}}
  {{- range $v := .Values.deployments.edm.customJvm }}
  {{- $customJvm:= split "=" $v }}
  {{- $customJvmKeysList = printf "%s" $customJvm._0 | append $customJvmKeysList -}}
  {{- end }}
  customJvmKeys : {{ $customJvmKeysList | join " " }}

  databaseSchemas: {{ $.Values.jobs.databaseSchemas.create }}

  ### Database Schemas Details - Repository
  {{- $databaseSchemaRepository := "" }}
  {{- range $i, $v := .Values.database.schemas }}
  {{- if eq $v.referenceName "Repository" }}
  {{- $databaseSchemaRepository = print $v.gem.owner }}
  {{- end }}
  {{- end }}
  
  ### Database Schemas Details
  {{- $databaseSchemaDetails := "" }}
  {{- range $i, $v := .Values.database.schemas }}
  {{- if $i }}
  {{- $databaseSchemaDetails = print $databaseSchemaDetails " " }}
  {{- end }}
  {{- $databaseSchemaDetails = print $databaseSchemaDetails $v.referenceName ":" $v.gem.owner ":" "gemOwnerPassword" ":" $v.gem.user ":" "gemUserPassword" ":" $databaseSchemaRepository ":" $v.name }}
  {{- end }}
  databaseSchemaDetails: {{ $databaseSchemaDetails }}

  ### Default Orchestrator
  {{- $orchestrator := "None" }}
  {{- range $k, $v := $applications.applications -}}
  {{- if (eq $v.type "Orchestrator") }}
  {{- if eq $orchestrator "None" }}
  {{- $orchestrator = print $k }}
  {{- end }}
  {{- end }}
  {{- end }}
  defaultOrchestrator: {{ printf "%s" (trim (lower $orchestrator) ) }}
  defaultOrchestratorInternalLB: {{ printf "KUBE_INTERNAL_LB_%s" (trim (lower $orchestrator) ) }}
  defaultOrchestratorPort: {{ printf "%s_SERVICE_PORT" (trim (upper $orchestrator) ) }}

  ### Log mode
  logMode: {{ "INFO ERROR" }}  

  ### timezone
  timezone: {{ $.Values.deployments.timezone }}  

  ### partition
  partition: {{ $.Values.deployments.edm.partition }}  

  ### Create EDM secrets
  createSecret: {{ $.Values.deployments.secret.create }}
  
  ### External DNS
  externalDns: {{ $.Values.cluster.externalDns.create }}

  ### Database Option
  {{- if $.Values.dropDatabase }}
  databaseOptionChosen: "dropDatabase"
  processApplications: false 
  processJobs: false
  {{ else if $.Values.backupDatabase }}
  databaseOptionChosen: "backupDatabase"
  processApplications: true
  processJobs: false
  {{ else if $.Values.restoreDatabase }}
  databaseOptionChosen: "restoreDatabase"
  processApplications: false
  processJobs: false
  {{ else }} 
  databaseOptionChosen: "None"
  processApplications: true
  processJobs: true
  {{- end }}

  ### Jolokia Details
  edm_jolokia: "false"
  {{- range $j := .Values.deployments.edm.applications -}}
  {{- if and (eq $j.name "JvmMonitoring") $j.enabled }}
  edm_jolokia: "true"
  {{- end }}
  {{- end }}

  ### Mount Details
  edm_mount: "false"
  {{- if (eq $.Values.cluster.artefacts.path.application "mount") }}
  edm_mount: "true"
  {{- end }}

  ### EDM Production
  edm_production: "false"
  {{- if $.Values.common.production }}
  edm_production: "true"
  {{- end }}

{{- end }}
