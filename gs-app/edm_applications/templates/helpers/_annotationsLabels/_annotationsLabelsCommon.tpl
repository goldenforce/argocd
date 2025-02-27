{{/*
Create Common annotations/labels
*/}}
{{- define "annotationsLabels" -}}
common:
  annotations:
    {{- with $.Values.common.annotations}}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  labels:
    {{- with $.Values.common.labels }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
