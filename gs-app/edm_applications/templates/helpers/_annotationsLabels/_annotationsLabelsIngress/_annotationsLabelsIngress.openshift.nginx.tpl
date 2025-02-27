{{/*
Create Ingress annotations/labels - ui
*/}}
{{- define "annotationsLabelsIngressNginxUiOpenshift" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
ui:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations
    nginx.ingress.kubernetes.io/affinity-mode: "persistent"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
    nginx.ingress.kubernetes.io/proxy-buffers-number: "4"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS

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
{{- define "annotationsLabelsIngressNginxOrchestratorOpenshift" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
orchestrator:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations
    nginx.ingress.kubernetes.io/affinity-mode: "persistent"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
    nginx.ingress.kubernetes.io/proxy-buffers-number: "4"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS

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
{{- define "annotationsLabelsIngressNginxDatabaseOpenshift" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
database:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations
    nginx.ingress.kubernetes.io/affinity-mode: "persistent"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
    nginx.ingress.kubernetes.io/proxy-buffers-number: "4"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS

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

