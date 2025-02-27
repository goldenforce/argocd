{{/*
Create Service annotations/labels
*/}}
{{- define "annotationsLabelsServiceDefaultOpenshift" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
service:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    # Include required annotations
    {{- if eq "internet-facing" $.Values.ingresses.lb.scheme }}
    {{ else }}
    {{- end}}
{{- end }}
