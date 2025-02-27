{{/*
Create Ingress annotations/labels - ui
*/}}
{{- define "annotationsLabelsIngressDefaultUiOpenshift" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
ui:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations
    route.openshift.io/termination: reencrypt

    # Include default annotations
    {{- with $.Values.ingresses.default.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    
    # Include custom annotations
    {{- with $.Values.ingresses.ingress.ui.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  labels:
    # Include common labels
    {{- with $annotationsLabelsCommon.common.labels }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
{{- end }}

{{/*
Create Ingress annotations/labels - orchestrator
*/}}
{{- define "annotationsLabelsIngressDefaultOrchestratorOpenshift" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
orchestrator:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations

    # Include default annotations
    {{- with $.Values.ingresses.default.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

  labels:
    # Include common labels
    {{- with $annotationsLabelsCommon.common.labels }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
{{- end }}

{{/*
Create Ingress annotations/labels - database
*/}}
{{- define "annotationsLabelsIngressDefaultDatabaseOpenshift" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
database:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations

    # Include default annotations
    {{- with $.Values.ingresses.default.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

  labels:
    # Include common labels
    {{- with $annotationsLabelsCommon.common.labels }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
{{- end }}

