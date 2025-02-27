{{/*
Create EDM Jobs
*/}}
{{- define "jobs" -}}
{{- $annotationsLabels := include "annotationsLabels" . | fromYaml }}
{{- $applications := include "applications" . | fromYaml }}
jobs:
  configureDatabase:
    serviceTlsGenerated: false
    enabled: true
    type: configureDatabase
    image: {{ $.Values.deployments.utilities.images.platform }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      "helm.sh/hook": post-install, post-upgrade
      "helm.sh/hook-weight": "101"
      "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded,hook-failed
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    {{- range $v := $.Values.deployments.utilities.applications -}}
    {{- if and (eq $v.name "DatabaseUtil") }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    {{- end }}
    {{- end }}
  {{- if (eq $.Values.cluster.artefacts.path.application "mount") }}
  configureMount:
    serviceTlsGenerated: false
    enabled: true
    type: configureMount
    image: {{ $.Values.deployments.edm.images.jboss }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      "helm.sh/hook": post-install, post-upgrade
      "helm.sh/hook-weight": "102"
      "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded,hook-failed
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    resources:
      limits:
        cpu: 0.2
        memory: "200Mi"
      requests:
        cpu: 0.1
        memory: "100Mi"
  {{- end }}
  {{- if $applications.applications.KeycloakInitialization }}
  configureKeycloak:
    serviceTlsGenerated: false
    enabled: true
    type: configureKeycloak
    image: {{ $applications.applications.KeycloakInitialization.image }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      "helm.sh/hook": post-install, post-upgrade
      "helm.sh/hook-weight": "103"
      "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded,hook-failed
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    {{- range $v := $.Values.deployments.utilities.applications -}}
    {{- if and (eq $v.name "KeycloakInitialization") }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    {{- end }}
    {{- end }}
  {{- end }}
  configureGemDomainsRoles:
    serviceTlsGenerated: false
    enabled: true
    type: configureGemDomainsRoles
    image: {{ $applications.applications.GEM.image }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      "helm.sh/hook": post-install, post-upgrade
      "helm.sh/hook-weight": "104"
      "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded,hook-failed
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    {{- range $v := $.Values.deployments.utilities.applications -}}
    {{- if and (eq $v.name "GEM") }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    {{- end }}
    {{- end }}
  allJobsEnd:
    serviceTlsGenerated: false
    enabled: true
    type: allJobsEnd
    image: {{ $.Values.deployments.utilities.images.platform }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      "helm.sh/hook": post-install, post-upgrade
      "helm.sh/hook-weight": "999"
      "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded,hook-failed
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    {{- range $v := $.Values.deployments.utilities.applications -}}
    {{- if and (eq $v.name "DatabaseUtil") }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    {{- end }}
    {{- end }}
  {{- if $applications.applications.DatabaseUtil }}
  databaseOperations:
    serviceTlsGenerated: false
    {{- if or (eq $.Values.dropDatabase true) (eq $.Values.restoreDatabase true) (eq $.Values.backupDatabase true) }}
    enabled: true
    {{- else }}
    enabled: false
    {{- end }}  
    type: databaseOperations
    image: {{ $applications.applications.DatabaseUtil.image }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      "helm.sh/hook": post-install, post-upgrade
      "helm.sh/hook-weight": "100"
      "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded,hook-failed
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    {{- range $v := $.Values.deployments.utilities.applications -}}
    {{- if and (eq $v.name "DatabaseUtil") }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    {{- end }}
    {{- end }}
  {{- end }}
  {{- if $applications.applications.EDMA }}
  configureEdma:
    serviceTlsGenerated: false
    enabled: {{ $.Values.jobs.applications.edma.enabled }}
    type: configureEdma
    image: {{ $applications.applications.EDMA.image }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      "helm.sh/hook": post-install, post-upgrade
      "helm.sh/hook-weight": "105"
      "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded,hook-failed
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    {{- range $v := $.Values.deployments.utilities.applications -}}
    {{- if and (eq $v.name "EDMA") }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
