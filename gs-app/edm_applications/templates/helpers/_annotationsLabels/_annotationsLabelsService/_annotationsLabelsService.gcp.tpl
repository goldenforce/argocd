{{/*
Create Service annotations/labels
*/}}
{{- define "annotationsLabelsServiceGcp" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
service:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    # Include required annotations
    cloud.google.com/app-protocols: '{"https" : "HTTPS"}'
    {{- if eq "internet-facing" $.Values.ingresses.lb.scheme }}
    {{ else }}
    {{- end}}
{{- end }}
