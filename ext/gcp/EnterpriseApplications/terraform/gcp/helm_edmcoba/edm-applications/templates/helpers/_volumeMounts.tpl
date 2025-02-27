{{/*
####################################################
Create EDM Applications Volume Mounts
*/}}
{{- define "volumeMounts" -}}
### Basic, Annotations
{{- $basic := include "basic" . | fromYaml }}
### Applications
{{- $applications := include "applications" . | fromYaml }}
### Jobs
{{- $jobs := include "jobs" . | fromYaml }}
### Cron job
{{- $cronjobs := include "cronjobs" . | fromYaml }}
{{- range $k, $v := merge $applications.applications $jobs.jobs $cronjobs.cronjobs }}
{{ printf "%s" $k }}:
   volumeMounts:
   - name: edm-disk-share 
     mountPath: {{ $basic.basic.persistentVolume.path }}
   - name: edm-applications-secret
     mountPath: /etc/edm
{{- end }}
{{- end }}
