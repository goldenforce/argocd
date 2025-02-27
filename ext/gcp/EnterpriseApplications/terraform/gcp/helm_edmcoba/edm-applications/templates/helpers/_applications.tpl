{{/*
####################################################
Create EDM Applications
*/}}
{{- define "applications" -}}
applications:
  {{- range $v := .Values.deployments.edm.applications -}}
  {{- if and (eq $v.name "Workstation") $v.enabled }}
  Workstation:
    serviceTlsGenerated: true
    type: Non-Orchestrator
    contextPathDefault: "/GS" 
    contextPaths: 
    - /GS
    - /SSO
    - /EDM
    port: 8543
    portOffset: 100
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{ $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "1800"
  {{- end }}
  {{- if and (eq $v.name "WorkstationDWH") $v.enabled }}
  WorkstationDWH:
    serviceTlsGenerated: true
    type: Non-Orchestrator
    contextPathDefault: "/GSDwh" 
    contextPaths: 
    - /GSDwh
    port: 8643
    portOffset: 200
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "1800"
  {{- end }}
  {{- if and (eq $v.name "Standardvddb") $v.enabled }}
  Standardvddb:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/standardvddb/rest/events" 
    contextPaths: 
    - /standardvddb
    port: 8743
    portOffset: 300
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Standardui") $v.enabled }}
  Standardui:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/standardui/rest/events" 
    contextPaths: 
    - /standardui
    port: 9273
    portOffset: 830
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Standardgc") $v.enabled }}
  Standardgc:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/standardgc/rest/events" 
    contextPaths: 
    - /standardgc
    port: 8843
    portOffset: 400
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Fileloading") $v.enabled }}
  Fileloading:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/fileloading/rest/events" 
    contextPaths: 
    - /fileloading
    port: 8943
    portOffset: 500
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Publishing") $v.enabled }}
  Publishing:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/publishing/rest/events" 
    contextPaths: 
    - /publishing
    port: 9043
    portOffset: 600
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Pricing") $v.enabled }}
  Pricing:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/pricing/rest/events" 
    contextPaths: 
    - /pricing
    port: 9143
    portOffset: 700
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Standarddw") $v.enabled }}
  Standarddw:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/standarddw/rest/events" 
    contextPaths: 
    - /standarddw
    port: 9243
    portOffset: 800
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Pipeline") $v.enabled }}
  Pipeline:
    serviceTlsGenerated: true
    type: Orchestrator
    contextPathDefault: "/pipeline/rest/events" 
    contextPaths: 
    - /pipeline
    port: 9268
    portOffset: 825
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "GSOService") $v.enabled }}
  GSOService:
    serviceTlsGenerated: true
    type: Non-Orchestrator
    contextPathDefault: "/GSOService" 
    contextPaths: 
    - /GSOService
    port: 8593
    portOffset: 150
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Flowstudio") $v.enabled }}
  Flowstudio:
    serviceTlsGenerated: true
    type: Non-Orchestrator
    contextPathDefault: "/Flowstudio" 
    contextPaths: 
    - /Flowstudio
    port: 8693
    portOffset: 250
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "JvmMonitoring") $v.enabled }}
  JvmMonitoring:
    serviceTlsGenerated: true
    type: JvmMonitoring
    contextPathDefault: "/hawtio" 
    contextPaths: 
    - /hawtio
    port: 4380
    portOffset: 950
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.jboss }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: "admin"
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- if and (eq $v.name "Keycloak") $v.enabled }}
  Keycloak:
    serviceTlsGenerated: true
    type: Non-Orchestrator
    contextPathDefault: "/auth" 
    contextPaths: 
    - /auth
    port: 9343
    portOffset: 900
    replicas: {{ $v.replicas }}
    image: {{ $.Values.deployments.edm.images.keycloak }}
    local_home: "/ext/app/jbossstandalone/software/keycloak"
    roles: []
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
      hpa:
        minReplicas: {{ $v.resources.hpa.minReplicas }} 
        maxReplicas: {{ $v.resources.hpa.maxReplicas }} 
        averageUtilization: {{ $v.resources.hpa.averageUtilization }} 
        scaleUpStabilizationWindowSeconds: {{ $v.resources.hpa.scaleUpStabilizationWindowSeconds }} 
        scaleUpPeriodSeconds: {{ $v.resources.hpa.scaleUpPeriodSeconds }} 
        scaleDownStabilizationWindowSeconds: {{ $v.resources.hpa.scaleDownStabilizationWindowSeconds }} 
        scaleDownPeriodSeconds: {{ $v.resources.hpa.scaleDownPeriodSeconds }} 
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
    curlSleepTime: "180"
  {{- end }}
  {{- end }}
  {{- range $v := .Values.deployments.utilities.applications -}}
  {{- if and (eq $v.name "Filebrowser") $v.enabled }}
  Filebrowser:
    serviceTlsGenerated: true
    type: Utilities
    contextPaths:
    - /filebrowser 
    port: 4180
    image: {{ $v.image }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "Quantworkbench") $v.enabled }}
  Quantworkbench:
    serviceTlsGenerated: true
    type: Utilities
    contextPaths:
    - /qwb
    port: 5000
    image: {{ $v.image }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "Cloudbeaver") $v.enabled }}
  Cloudbeaver:
    serviceTlsGenerated: true
    type: Utilities
    contextPaths:
    - /cloudbeaver
    port: 5500
    image: {{ $v.image }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "Jobscheduler") $v.enabled }}
  Jobscheduler:
    serviceTlsGenerated: true
    type: Utilities
    contextPaths:
    - /joc
    port: 7500
    image: {{ $v.image }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "Insight") $v.enabled }}
  Insight:
    serviceTlsGenerated: true
    type: Utilities
    contextPaths:
    - /ibi_apps
    port: 8444
    image: {{ $v.image }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "EDMA") $v.enabled }}
  EDMA:
    serviceTlsGenerated: true
    type: Utilities
    contextPathDefault: "/Automation" 
    contextPaths: 
    - /Automation
    port: 8603
    portOffset: 160
    replicas: {{ $v.replicas }}
    image: {{ $v.image }}
    local_home: "/ext/app/jbossstandalone/software/jboss"
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "Cleanup") $v.enabled }}
  Cleanup:
    serviceTlsGenerated: false
    type: Utilities
    contextPaths:
    port: 80
    image: {{ $v.image }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if (eq $v.name "GEM") }}
  GEM:
    serviceTlsGenerated: false
    type: Utilities
    contextPaths:
    port: 80
    image: {{ $v.image }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "DatabaseUtil") $v.enabled }}
  DatabaseUtil:
    serviceTlsGenerated: false
    type: Utilities
    contextPaths:
    port: 80
    image: {{ $v.image }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "KeycloakInitialization") $v.enabled }}
  KeycloakInitialization:
    serviceTlsGenerated: false
    type: Utilities
    contextPaths:
    port: 80
    image: {{ $v.image }}
    roles: {{ $v.roles | quote }}
    resources:
      limits:
        cpu: {{ $v.resources.limits.cpu }}
        memory: {{ $v.resources.limits.memory }}
      requests:
        cpu: {{ $v.resources.requests.cpu }}
        memory: {{ $v.resources.requests.memory }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- if and (eq $v.name "EDMA") $v.enabled }}
  selenium-hub:
    serviceTlsGenerated: true
    type: Utilities
    contextPaths: 
    - /selenium
    port: 6500
    portOffset: 100
    replicas: 1
    image: {{ $.Values.selenium.hub.image }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    local_home: "/ext/app"
    roles: []
    resources:
      limits:
        cpu: {{ 1 }}
        memory: {{ "2000Mi" }}
      requests:
        cpu: {{ 0.1 }}
        memory: {{ "10Mi" }}
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  selenium-chrome-node:
    serviceTlsGenerated: true
    type: Utilities
    contextPaths: 
    - /selenium
    port: 5555
    portOffset: 100
    replicas: 1
    image: {{ $.Values.selenium.hub.image }}
    imageGatekeeper: {{ $.Values.deployments.utilities.images.platform }}
    local_home: "/ext/app"
    roles: []
    resources:
      limits:
        cpu: {{ 1 }}
        memory: {{ "2000Mi" }}
      requests:
        cpu: {{ 0.1 }}
        memory: {{ "10Mi" }}
    probes:
      livenessProbe:
        failureThreshold: {{ $.Values.deployments.probes.livenessProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.livenessProbe.periodSeconds }}
      startupProbe:
        failureThreshold: {{ $.Values.deployments.probes.startupProbe.failureThreshold }}
        periodSeconds: {{ $.Values.deployments.probes.startupProbe.periodSeconds }}
    securityContext:
      runAsUser: {{ $.Values.deployments.securityContext.runAsUser }}
      runAsGroup: {{  $.Values.deployments.securityContext.runAsGroup }}
      fsGroup: {{ $.Values.deployments.securityContext.fsGroup }}
      fsGroupChangePolicy: "OnRootMismatch"
  {{- end }}
  {{- end }}
{{- end }}
