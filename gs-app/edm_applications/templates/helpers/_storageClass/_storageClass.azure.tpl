{{/*
####################################################
Create the storage class for EDM
*/}}
{{- define "storageClassAzure" -}}
storageClass:
  storage: {{ .Values.persistentVolume.storage }}
  metadata:
    name: {{ $.Values.persistentVolume.storageClass.name }}
    annotations:
      {{- with $.Values.common.annotations}}
      {{ toYaml . | nindent 6 }}
      {{- end }}
    labels:
      {{- with $.Values.common.labels }}
      {{ toYaml . | nindent 6 }}
      {{- end }}
  {{ if eq $.Values.persistentVolume.storageClass.type "azurefile" }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      skuName: Premium_LRS
    provisioner: {{ "file.csi.azure.com" }}
    allowVolumeExpansion: true
    volumeBindingMode: Immediate
    mountOptions:
      - dir_mode=0777
      - file_mode=0777
      - uid={{ .Values.deployments.securityContext.runAsUser }}
      - gid={{ .Values.deployments.securityContext.runAsGroup }}
      - mfsymlinks
      - cache=strict
      - actimeo=30
  persistentVolumeClaimAccessMode: ReadWriteOnce
  {{- end }}
{{- end }}
