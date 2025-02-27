{{/*
####################################################
Create the storage class for EDM
*/}}
{{- define "storageClass" -}}
{{- if eq $.Values.common.cloud "azure" }}
{{ include "storageClassAzure" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "aws" }}
{{ include "storageClassAws" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "gcp" }}
{{ include "storageClassGcp" . | indent 0 }}
{{- end }}
{{- if eq $.Values.common.cloud "openshift" }}
{{ include "storageClassOpenshift" . | indent 0 }}
{{- end }}
{{- end }}
