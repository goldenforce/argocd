{{/*
####################################################
Create the storage class for EDM
*/}}
{{- define "storageClassGcp" -}}
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
  {{ if eq $.Values.persistentVolume.storageClass.type "pd-balanced" }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      type: pd-balanced
    provisioner: {{ "pd.csi.storage.gke.io" }}
    volumeBindingMode: Immediate
  persistentVolumeClaimAccessMode: ReadWriteOnce
  {{ else if eq $.Values.persistentVolume.storageClass.type "pd-premium" }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      type: pd-ssd
    provisioner: {{ "pd.csi.storage.gke.io" }}
    volumeBindingMode: Immediate
  persistentVolumeClaimAccessMode: ReadWriteOnce
  {{ else if eq $.Values.persistentVolume.storageClass.type "filestore-standard" }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      tier: standard
      network: {{ $.Values.persistentVolume.storageClass.network }}
      connect-mode: PRIVATE_SERVICE_ACCESS
    provisioner: {{ "filestore.csi.storage.gke.io" }}
    volumeBindingMode: WaitForFirstConsumer
  persistentVolumeClaimAccessMode: ReadWriteMany
  {{ else if eq $.Values.persistentVolume.storageClass.type "filestore-premium" }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      tier: premium
      network: {{ $.Values.persistentVolume.storageClass.network }}
      connect-mode: PRIVATE_SERVICE_ACCESS
    provisioner: {{ "filestore.csi.storage.gke.io" }}
    volumeBindingMode: WaitForFirstConsumer
  persistentVolumeClaimAccessMode: ReadWriteMany
  {{ else }}
  configurations:
    reclaimPolicy: Retain
    parameters:
      type: pd-standard
    provisioner: {{ "kubernetes.io/gce-pd" }}
    volumeBindingMode: Immediate
  persistentVolumeClaimAccessMode: ReadWriteOnce
  {{- end }}
{{- end }}
