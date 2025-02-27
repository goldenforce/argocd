{{/*
####################################################
Create EDM Applications Volumes
*/}}
{{- define "volumes" -}}
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
   volumes:
   - name: edm-disk-share
     persistentVolumeClaim:
       claimName: edm-persistent-volume-claim
   - name: edm-applications-secret
     emptyDir: {}
   {{- if and (eq $.Values.common.cloud "openshift") (eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default") ($v.serviceTlsGenerated) }}
   - name: edm-openshift-secret
     secret:
       secretName: {{ printf "edm-openshift-%s" (lower $k) }}
   {{- end }}
{{- end }}
{{- end }}
