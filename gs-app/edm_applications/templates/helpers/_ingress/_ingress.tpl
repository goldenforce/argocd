{{/*
####################################################
Create Ingress
*/}}
{{- define "ingresses" -}}
{{- if eq $.Values.common.cloud "azure" }}
{{ include "ingressesAzure" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "alb" }}
{{ include "ingressesAlbAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "nlb" }}
{{ include "ingressesNlbAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "gcp" }}
{{ include "ingressesGcp" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default" }}
{{ include "ingressesDefaultOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "nginx" }}
{{ include "ingressesNginxOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- end }}
