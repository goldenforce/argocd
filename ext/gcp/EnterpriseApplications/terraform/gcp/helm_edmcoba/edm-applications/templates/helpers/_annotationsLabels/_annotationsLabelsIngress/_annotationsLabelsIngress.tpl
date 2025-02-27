{{/*
####################################################
Create Ingress annotations/labels - ui
*/}}
{{- define "annotationsLabelsIngressUi" -}}
{{- if eq $.Values.common.cloud "azure" }}
{{ include "annotationsLabelsIngressUiAzure" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "alb" }}
{{ include "annotationsLabelsIngressAlbUiAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "nlb" }}
{{ include "annotationsLabelsIngressNlbUiAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "gcp" }}
{{ include "annotationsLabelsIngressUiGcp" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default" }}
{{ include "annotationsLabelsIngressDefaultUiOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "nginx" }}
{{ include "annotationsLabelsIngressNginxUiOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create Ingress annotations/labels - orchestrator
*/}}
{{- define "annotationsLabelsIngressOrchestrator" -}}
{{- if eq $.Values.common.cloud "azure" }}
{{ include "annotationsLabelsIngressOrchestratorAzure" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "alb" }}
{{ include "annotationsLabelsIngressAlbOrchestratorAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "nlb" }}
{{ include "annotationsLabelsIngressNlbOrchestratorAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "gcp" }}
{{ include "annotationsLabelsIngressOrchestratorGcp" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default" }}
{{ include "annotationsLabelsIngressDefaultOrchestratorOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "nginx" }}
{{ include "annotationsLabelsIngressNginxOrchestratorOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create Ingress annotations/labels - database
*/}}
{{- define "annotationsLabelsIngressDatabase" -}}
{{- if eq $.Values.common.cloud "azure" }}
{{ include "annotationsLabelsIngressDatabaseAzure" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "alb" }}
{{ include "annotationsLabelsIngressAlbDatabaseAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{- if eq $.Values.ingresses.lb.type "nlb" }}
{{ include "annotationsLabelsIngressNlbDatabaseAws" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "gcp" }}
{{ include "annotationsLabelsIngressDatabaseGcp" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default" }}
{{ include "annotationsLabelsIngressDefaultDatabaseOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{- if eq $.Values.ingresses.ingress.ui.ingressClassName "nginx" }}
{{ include "annotationsLabelsIngressNginxDatabaseOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
{{- end }}

