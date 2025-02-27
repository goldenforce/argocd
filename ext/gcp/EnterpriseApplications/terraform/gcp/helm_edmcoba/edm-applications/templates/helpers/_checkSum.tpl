{{/*
Create Checksum definitions
*/}}
{{- define "checkSumQualified" -}}
{{- $configMap := include "configMap" . | fromYaml }}
{{- $configMapScripts := include "configMapScripts" . | fromYaml }}
{{- $configMapConfigurations := include "configMapConfigurations" . | fromYaml }}
{{- $configMapFunctions := include "configMapFunctions" . | fromYaml }}
data:
  {{- range $k, $v := $configMap.data -}}
  {{- $key:= split ":" $v }}
  {{- if (ne $k "edm_execution_date") }}
  {{ $k }}: {{ $v | quote }} 
  {{- end }}
  {{- end }}
  {{- range $k, $v := $configMapScripts.data -}}
  {{- $key:= split ":" $v }}
  {{ $k }}: {{ $v | quote }} 
  {{- end }}
  {{- range $k, $v := $configMapConfigurations.data -}}
  {{- $key:= split ":" $v }}
  {{ $k }}: {{ $v | quote }} 
  {{- end }}
  {{- range $k, $v := $configMapFunctions.data -}}
  {{- $key:= split ":" $v }}
  {{ $k }}: {{ $v | quote }} 
  {{- end }}
{{- end }}

{{- define "checkSum" -}}
{{- $checkSumQualified := include "checkSumQualified" . | fromYaml }}
{{- $secret := include "secret" . | fromYaml }}
data:
  configMap: {{ $checkSumQualified.data | toJson }}
  secret: {{ $secret | toJson }}
  secretStringData: {{ $secret.stringData | toJson | b64dec | quote }}
{{- end }}
