{{/*
Create EDM Jobs
*/}}
{{- define "cronjobs" -}}
{{- $annotationsLabels := include "annotationsLabels" . | fromYaml }}
{{- $applications := include "applications" . | fromYaml }}
cronjobs:
  cleanup:
    enabled: {{ $.Values.jobs.cron.cleanup.enabled }}
    before: {{ $.Values.jobs.cron.cleanup.before }}
    schedule: {{ $.Values.jobs.cron.cleanup.schedule | quote }}
    type: cleanup
    image: {{ $.Values.deployments.utilities.images.platform }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  reorgDatabase:
    enabled: {{ $.Values.jobs.cron.reorgDatabase.enabled }}
    before: {{ $.Values.jobs.cron.reorgDatabase.before }}
    schedule: {{ $.Values.jobs.cron.reorgDatabase.schedule | quote }}
    type: reorgDatabase
    image: {{ $.Values.deployments.utilities.images.platform }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- if $applications.applications.DatabaseUtil }}
  backupDatabase:
    enabled: {{ $.Values.jobs.cron.backupDatabase.enabled }}
    before: {{ $.Values.jobs.cron.backupDatabase.before }}
    schedule: {{ $.Values.jobs.cron.backupDatabase.schedule | quote }}
    type: backupDatabase
    image: {{ $applications.applications.DatabaseUtil.image }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  rdsEndpoint:
    {{- if and (eq $.Values.common.cloud "aws") (eq $.Values.ingresses.lb.type "nlb") $.Values.jobs.cron.rdsEndpoint.enabled }}
    enabled: true
    {{ else }}
    enabled: false
    {{- end }}
    before: {{ $.Values.jobs.cron.rdsEndpoint.before }}
    schedule: {{ $.Values.jobs.cron.rdsEndpoint.schedule | quote }}
    type: rdsEndpoint
    image: {{ $.Values.deployments.utilities.images.platform }}
    annotations:
      {{- with $annotationsLabels.common.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    labels:
      {{- with $annotationsLabels.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
{{- end }}
