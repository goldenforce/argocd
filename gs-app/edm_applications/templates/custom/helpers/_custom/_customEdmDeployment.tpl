{{/*
####################################################
Create EDM Applications Custom Init container for Secrets
*/}}
{{- define "custom" -}}
{{- $basic := include "basic" . | fromYaml }}
custom:
  env:
    {{ if (($.Values.proxyurl).proxy) }}
    - name: HTTP_PROXY
      value: {{ $.Values.proxyurl.proxy }}
    {{ end -}}
    {{ if (($.Values.proxyurl).proxy) }}
    - name: HTTPS_PROXY
      value: {{ $.Values.proxyurl.proxy }}
    {{ end -}}
    {{ if (($.Values.proxyurl).noproxy) }}
    - name: NO_PROXY
      value: {{ $.Values.proxyurl.noproxy }}
    {{ end -}}
    {{ if (($.Values.proxyurl).proxy) }}
    - name: http_proxy
      value: {{ $.Values.proxyurl.proxy }}
    {{ end -}}
    {{ if (($.Values.proxyurl).proxy) }}
    - name: https_proxy
      value: {{ $.Values.proxyurl.proxy }}
    {{ end -}}
    {{ if (($.Values.proxyurl).noproxy) }}
    - name: no_proxy
      value: {{ $.Values.proxyurl.noproxy }}
    {{ end -}}
    - name: edm_applications_secret_custom_scripts
      value: "/staging/secrets/datasource.properties"
    - name: TZ
      value: {{ $basic.basic.timezone }}
  initContainers:
    - name: iad-vault-fetcher-init
      resources:
        limits:
          cpu: 100m
          memory: 256Mi
        requests:
          cpu: 50m
          memory: 128Mi
      terminationMessagePath: /dev/termination-log
      command:
        - node
        - start/init.js
      env:
      - name: CLUSTER_ID
        value: {{ $.Values.cluster.clusterId }}
      - name: SECRETS_STR
        value: default
      - name: IAD_VAULT_MOUNT_PATH
        value: /staging/secrets/
      imagePullPolicy: Always
      volumeMounts:
      - name: iad-vault-extra-conf
        readOnly: true
        mountPath: /iad/vault/config
      - name: iad-vault-fetcher-volume
        readOnly: true
        mountPath: /iad/staging/secrets/iad-projected-volume
      - name: nuveen-golden-source-secrets
        mountPath: /staging/secrets/
      - name: nuveen-golden-source-secrets-template
        readOnly: true
        mountPath: /iad/staging/secrets-template
      terminationMessagePolicy: File
      image: 235676489194.dkr.ecr.us-east-1.amazonaws.com/org.tiaa.iad-vault-fetcher/iad-vault-fetcher:1.0.0.43
  volumeMounts:
    {{ if ((($.Values.persistentVolumeFsx).storageClassFsx).create) }}
    - name: fsx-share
      mountPath: fsx
    {{ end }}
    - name: nuveen-golden-source-secrets
      readOnly: true
      mountPath: /staging/secrets/
  volumes:  
    {{ if ((($.Values.persistentVolumeFsx).storageClassFsx).create) }}
    - name: fsx-share
      persistentVolumeClaim:
        claimName: {{ $.Values.persistentVolumeFsx.storageClassFsx.name }}
    {{ end }}
    - name: iad-vault-extra-conf
      configMap:
        name: iad-vault-extra-conf
        defaultMode: 420
        optional: true
    - name: nuveen-golden-source-secrets
      emptyDir:
        medium: Memory
    - name: nuveen-golden-source-secrets-template
      configMap:
        name: nuveen-golden-source-secrets-template
        defaultMode: 420
    - name: iad-vault-fetcher-volume
      projected:
        sources:
        - serviceAccountToken:
            audience: iad-vault-auth-fn
            expirationSeconds: 600
            path: vault-token
        - downwardAPI:
            items:
              - path: labels
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.labels
              - path: namespace
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.namespace
              - path: name
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.name
        defaultMode: 420
{{- end }}
