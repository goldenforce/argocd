{{/*
####################################################
Create Service annotations/labels
*/}}
{{- define "annotationsLabelsService" -}}
{{- if eq $.Values.common.cloud "azure" }}
{{ include "annotationsLabelsServiceAzure" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "alb" }}
{{ include "annotationsLabelsServiceAlbAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "nlb" }}
{{ include "annotationsLabelsServiceNlbAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "gcp" }}
{{ include "annotationsLabelsServiceGcp" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default" }}
{{ include "annotationsLabelsServiceDefaultOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "nginx" }}
{{ include "annotationsLabelsServiceNginxOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- end }}
