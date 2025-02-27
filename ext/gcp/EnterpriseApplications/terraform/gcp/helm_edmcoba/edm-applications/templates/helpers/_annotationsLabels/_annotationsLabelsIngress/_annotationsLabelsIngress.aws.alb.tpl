{{/*
Create Ingress annotations/labels - ui
*/}}
{{- define "annotationsLabelsIngressAlbUiAws" -}}
{{- $basic := include "basic" . | fromYaml }}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
ui:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/success-codes: 200-301
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
    alb.ingress.kubernetes.io/target-group-attributes: slow_start.duration_seconds=100,deregistration_delay.timeout_seconds=30,stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=600
    alb.ingress.kubernetes.io/inbound-cidrs: 10.0.0.0/8
    alb.ingress.kubernetes.io/load-balancer-attributes: "idle_timeout.timeout_seconds=600,deletion_protection.enabled=true"

    # Include default annotations
    {{- with $.Values.ingresses.default.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    
    # Include load balancer scheme
    {{- if eq "internet-facing" $.Values.ingresses.lb.scheme }}
    alb.ingress.kubernetes.io/scheme: "internet-facing"
    {{ else }}
    alb.ingress.kubernetes.io/scheme: "internal"
    {{- end}}

    # Include load balancer group
    {{- if $.Values.ingresses.lb.singleLoadBalancer }}
    alb.ingress.kubernetes.io/group.name: {{ printf "%s-ingress" $.Values.ingresses.ingressNamePrefix }}
    {{ else }}
    alb.ingress.kubernetes.io/group.name: {{ printf "%s-ui-ingress" $.Values.ingresses.ingressNamePrefix }}
    {{- end}}
    
    # Include required annotations - ui
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTPS
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/backend-protocol: HTTPS

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
{{- define "annotationsLabelsIngressAlbOrchestratorAws" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
orchestrator:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/success-codes: 200-301
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
    alb.ingress.kubernetes.io/target-group-attributes: slow_start.duration_seconds=100,deregistration_delay.timeout_seconds=30,stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=600
    alb.ingress.kubernetes.io/inbound-cidrs: 10.0.0.0/8
    alb.ingress.kubernetes.io/load-balancer-attributes: "idle_timeout.timeout_seconds=600,deletion_protection.enabled=true"

    # Include default annotations
    {{- with $.Values.ingresses.default.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    
    # Include load balancer scheme
    {{- if eq "internet-facing" $.Values.ingresses.lb.scheme }}
    alb.ingress.kubernetes.io/scheme: "internet-facing"
    {{ else }}
    alb.ingress.kubernetes.io/scheme: "internal"
    {{- end}}

    # Include required annotations - orchestrator
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTPS
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/backend-protocol: HTTPS

  labels:
    # Include common labels
    {{- with $annotationsLabelsCommon.common.labels }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
{{- end }}

{{/*
Create Ingress annotations/labels - database
*/}}
{{- define "annotationsLabelsIngressAlbDatabaseAws" -}}
{{- $annotationsLabelsCommon := include "annotationsLabels" . | fromYaml }}
database:
  annotations:
    # Include common annotations
    {{- with $annotationsLabelsCommon.common.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}

    # Include required annotations
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/success-codes: 200-301
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
    alb.ingress.kubernetes.io/target-group-attributes: slow_start.duration_seconds=100,deregistration_delay.timeout_seconds=30,stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=600
    alb.ingress.kubernetes.io/inbound-cidrs: 10.0.0.0/8
    alb.ingress.kubernetes.io/load-balancer-attributes: "idle_timeout.timeout_seconds=600,deletion_protection.enabled=true"

    # Include default annotations
    {{- with $.Values.ingresses.default.annotations }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
    
    # Include load balancer scheme
    {{- if eq "internet-facing" $.Values.ingresses.lb.scheme }}
    alb.ingress.kubernetes.io/scheme: "internet-facing"
    {{ else }}
    alb.ingress.kubernetes.io/scheme: "internal"
    {{- end}}

    # Include required annotations - database
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTPS
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/backend-protocol: HTTPS

  labels:
    # Include common labels
    {{- with $annotationsLabelsCommon.common.labels }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
