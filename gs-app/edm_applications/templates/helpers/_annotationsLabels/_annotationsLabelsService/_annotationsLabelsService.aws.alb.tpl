{{/*
Create Service annotations/labels
*/}}
{{- define "annotationsLabelsServiceAlbAws" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
service:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    # Include required annotations
    alb.ingress.kubernetes.io/success-codes: "200"
    {{- if eq "internet-facing" $.Values.ingresses.lb.scheme }}
    {{ else }}
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
    {{- end}}
{{- end }}
