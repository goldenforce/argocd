{{/*
####################################################
Create the storage class for EDM
*/}}
{{- define "storageClassAws" -}}
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
  {{ if eq $.Values.persistentVolume.storageClass.type "ebs" }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      type: gp2
    provisioner: {{ "kubernetes.io/aws-ebs" }}
    volumeBindingMode: Immediate
  persistentVolumeClaimAccessMode: ReadWriteOnce
  {{- end }}
  {{ if eq $.Values.persistentVolume.storageClass.type "efs" }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      provisioningMode: efs-ap
      fileSystemId: {{ .Values.persistentVolume.fileSystemId }}
      directoryPerms: "700"
    provisioner: {{ "efs.csi.aws.com" }}
    volumeBindingMode: Immediate
  persistentVolumeClaimAccessMode: ReadWriteMany
  {{- end }}
{{- end }}
