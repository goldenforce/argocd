{/*
####################################################
Create Ingresses
*/}}
{{- define "ingressesGcp" -}}
{{- $basic := include "basic" . | fromYaml }}
{{- $applications := include "applications" . | fromYaml }}
{{- $ingressAnnotationsUi := include "annotationsLabelsIngressUi" . | fromYaml }}
{{- $ingressAnnotationsOrchestrator := include "annotationsLabelsIngressOrchestrator" . | fromYaml }}
{{- $ingressAnnotationsDatabase := include "annotationsLabelsIngressDatabase" . | fromYaml }}
role: {{ printf "%s-ingress-role" $.Values.cluster.environment.name }}
ingresses:
  ui:
    spec:
      ingressClassName: {{ $.Values.ingresses.ingress.ui.ingressClassName | quote }}
    name: {{ "edm-ui-ingress" }}
    type: Non-Orchestrator
    host: {{ $.Values.ingresses.ingress.ui.host }}
    port: 443
    annotations:
      # External DNS
      {{- if $basic.basic.cloud.ingressExternalDns }}
      external-dns.alpha.kubernetes.io/hostname: {{ $.Values.ingresses.ingress.ui.host }}
      {{- end }}

      # Include ui annotations
      {{- with $ingressAnnotationsUi.ui.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    secret:
      create: true 
      name: {{ "edm-ui-tls-secret" }}
    tls:
      tlsCrtFile: {{ printf "%s%s%s" "protected/Certificates/" "ui" "/certificate.crt" }}
      tlsKeyFile: {{ printf "%s%s%s" "protected/Certificates/" "ui" "/private.key" }}
    tcpConfigMap:
      create: false
      name: None
  {{- range $k, $v := $applications.applications -}}
  {{ if (eq $v.type "Orchestrator" ) }}
  {{ lower $k }}:
    name: {{ printf "%s-%s-%s" "edm" (lower $k) "ingress" }}
    type: Orchestrator
    {{- range $kTls, $vTls := $.Values.ingresses.ingress }}
    {{- if eq $kTls $k }}
    spec:
      ingressClassName: {{ $vTls.ingressClassName | quote }}
    host: {{ $vTls.host }}
    port: {{ $v.port }}
    annotations:
      # External DNS
      {{- if $basic.basic.cloud.ingressExternalDns }}
      external-dns.alpha.kubernetes.io/hostname: {{ $vTls.host }}
      {{- end }}

      # Include Orchestrator annotations
      {{- with $ingressAnnotationsOrchestrator.orchestrator.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
      
      # Include custom annotations
      {{- with $vTls.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{ if $.Values.ingresses.lb.singleLoadBalancer }}
    secret: 
      create: false
      name: {{ "edm-ui-tls-secret" }}
    tls:
      tlsCrtFile: {{ printf "%s%s%s" "protected/Certificates/" "ui" "/certificate.crt" }}
      tlsKeyFile: {{ printf "%s%s%s" "protected/Certificates/" "ui" "/private.key" }}
    tcpConfigMap:
      create: true
      name: {{ printf "%s-%s-%s-%s-%s" "edm" (lower $k) "tcp" "config" "map" }}
    {{ else }}
    secret: 
      create: true
      name: {{ printf "%s-%s-%s-%s" "edm" (lower $k) "tls" "secret" }}
    tls:
      tlsCrtFile: {{ printf "%s%s%s" "protected/Certificates/" $k "/certificate.crt" }}
      tlsKeyFile: {{ printf "%s%s%s" "protected/Certificates/" $k "/private.key" }}
    tcpConfigMap:
      create: false
      name: None
    {{- end }}
  {{- end }}
  {{- end }}

  database:
    spec:
      ingressClassName: {{ $.Values.ingresses.ingress.database.ingressClassName | quote }}
    name: {{ "edm-database-ingress" }}
    type: Database
    host: {{ $.Values.ingresses.ingress.database.host }}
    port: {{ $.Values.database.port }}
    annotations:
      # External DNS
      {{- if $basic.basic.cloud.ingressExternalDns }}
      external-dns.alpha.kubernetes.io/hostname: {{ $.Values.ingresses.ingress.database.host }}
      {{- end }}

      # Include Database annotations
      {{- with $ingressAnnotationsDatabase.database.annotations }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    secret: 
      create: false
      name: {{ "edm-ui-tls-secret" }}
    tls:
      tlsCrtFile: {{ printf "%s%s%s" "protected/Certificates/" "ui" "/certificate.crt" }}
      tlsKeyFile: {{ printf "%s%s%s" "protected/Certificates/" "ui" "/private.key" }}
    tcpConfigMap:
      create: true
      name: {{ printf "%s-%s-%s-%s-%s" "edm" "database" "tcp" "config" "map" }}
{{- end }}
