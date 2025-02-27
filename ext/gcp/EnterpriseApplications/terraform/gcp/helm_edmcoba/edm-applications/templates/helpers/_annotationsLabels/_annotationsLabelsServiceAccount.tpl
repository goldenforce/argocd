{{/*
Create Ingress annotations/labels - ui
*/}}
{{- define "annotationsLabelsServiceAccount" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
serviceAccount:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    # Include Service Account annotations
    {{- with $.Values.cluster.serviceAccount.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  labels:
    # Include common labels
    {{- with $annotationsLabelsCommon.common.labels }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
