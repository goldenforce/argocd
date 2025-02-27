{{/*
####################################################
Create EDM Applications Init container for Secrets
*/}}
{{- define "initContainer" -}}
### Basic, Annotations
{{- $basic := include "basic" . | fromYaml }}
### Applications
{{- $applications := include "applications" . | fromYaml }}
### Jobs
{{- $jobs := include "jobs" . | fromYaml }}
### Cron job
{{- $cronjobs := include "cronjobs" . | fromYaml }}
{{- range $k, $v := merge $applications.applications $jobs.jobs $cronjobs.cronjobs }}
{{ printf "%s" $k }}:
   initContainers:
   - name: edm-init-secret
     image: {{ $.Values.deployments.edm.images.jboss }}
     imagePullPolicy: {{ $basic.basic.imagePullPolicy }}
     env:
     - name: cloudEnvironment
       value: "{{ $.Values.common.cloud }}"
     - name: ingressClass
       value: "{{ $.Values.ingresses.ingress.ui.ingressClassName }}"
     - name: serviceTlsGenerated
       value: {{ $v.serviceTlsGenerated | default "false" | quote }}
     envFrom:
     - secretRef:
         name: edm-applications-secret          
     - configMapRef:
         name: edm-scripts-config-map
     - configMapRef:
         name: edm-configurations-config-map
     - configMapRef:
         name: edm-functions-config-map
     command: ["/bin/sh", "-c"]
     args: 
     - |
       ### Patterns
       mkdir -p /etc/edm/secret
       patterns="Database Service GEM Schema Certificate Elasticsearch Keycloak KEYCLOAK Docapi Orchestrator {{ $basic.basic.customJvmKeys }} Application"
       envFile=temp.txt
       envFileDecode=/etc/edm/secret/edm-applications-secret.env
       for pattern in $patterns;
       do
          env | grep ^$pattern | while read kv; do echo "$kv" >> $envFile; done
       done
       sort $envFile | uniq > ${envFileDecode}

       ### Certificates
       mkdir -p /etc/edm/secret/protected/Certificates
       patterns=`env | grep ^protected_ | cut -d "=" -f 1`
       for pattern in $patterns;
       do
          key="${pattern}"
          fileName="files_${key}"
          fileName=${!fileName}
          fileName=`echo ${fileName} | base64 -d` 
          mkdir -p $(dirname /etc/edm/secret/${fileName})
          echo "${!key}" | base64 --decode > /etc/edm/secret/${fileName}
       done
         
       ### Configurations
       mkdir -p /etc/edm/configurations
       patterns=`env | grep ^configurations_ | cut -d "=" -f 1`
       for pattern in $patterns;
       do
          key="${pattern}"
          fileName="files_${key}"
          fileName=${!fileName}
          fileName=`echo ${fileName} | base64 -d` 
          mkdir -p $(dirname /etc/edm/${fileName})
          echo "${!key}" | base64 --decode > /etc/edm/${fileName}
       done
       chmod -R +x /etc/edm/configurations

       ### Functions
       mkdir -p /etc/edm/functions
       patterns=`env | grep ^functions_ | cut -d "=" -f 1`
       for pattern in $patterns;
       do
          key="${pattern}"
          fileName="files_${key}"
          fileName=${!fileName}
          fileName=`echo ${fileName} | base64 -d` 
          mkdir -p $(dirname /etc/edm/${fileName})
          echo "${!key}" | base64 --decode > /etc/edm/${fileName}
       done
       chmod +x /etc/edm/functions/edm_functions.sh

       ### Scripts
       mkdir -p /etc/edm/scripts
       patterns=`env | grep ^scripts_ | cut -d "=" -f 1`
       for pattern in $patterns;
       do
          key="${pattern}"
          fileName="files_${key}"
          fileName=${!fileName}
          fileName=`echo ${fileName} | base64 -d` 
          mkdir -p $(dirname /etc/edm/${fileName})
          echo "${!key}" | base64 --decode > /etc/edm/${fileName}
       done
       chmod -R +x /etc/edm/scripts
         
       ### Openshift certificates for ingess class - openshift-default
       if [ "$cloudEnvironment" == "openshift" ] && [ "$ingressClass" == "openshift-default" ] && [ "$serviceTlsGenerated" == "true" ]; then
          mkdir -p /tmp
          cd /tmp
          openssl pkcs12 -export -in /etc/edm/openshift/tls.crt -inkey /etc/edm/openshift/tls.key -out keystore.p12 -name "${Certificate_identityKeyStoreAlias}" -password pass:${Certificate_identityKeyStorePassphrase} 
          keytool -importkeystore -srckeystore keystore.p12 -srcstoretype PKCS12 -destkeystore keystore.jks -deststoretype JKS -srcstorepass ${Certificate_identityKeyStorePassphrase} -deststorepass ${Certificate_identityKeyStorePassphrase}
          cp keystore.jks /etc/edm/secret/protected/Certificates/identity.jks
          cp keystore.jks /etc/edm/secret/protected/Certificates/trust.jks
          cp /etc/edm/openshift/tls.key /etc/edm/secret/protected/Certificates/ui/private.key  
          cp /etc/edm/openshift/tls.crt /etc/edm/secret/protected/Certificates/ui/certificate.crt
          touch /etc/edm/secret/protected/ui/dummy.crt
          touch /etc/edm/secret/protected/ui/dummy.cer
          cat /etc/edm/secret/protected/ui/*.crt  >> /tmp/service-ca.crt
          cat /etc/edm/secret/protected/ui/*.cer  >> /tmp/service-ca.crt
          csplit -z -f crt- /tmp/service-ca.crt "/-----BEGIN CERTIFICATE-----/" "{*}" 2> /dev/null
          for file in crt-*;
          do
             keytool -import -noprompt -keystore /etc/edm/secret/protected/Certificates/trust.jks -file $file -storepass ${Certificate_identityKeyStorePassphrase} -alias ${file}-${Certificate_identityKeyStoreAlias} 2> /dev/null
          done
       fi
     volumeMounts:
       - mountPath: /etc/edm
         name: edm-applications-secret
       {{- if and (eq $.Values.common.cloud "openshift") (eq $.Values.ingresses.ingress.ui.ingressClassName "openshift-default") ($v.serviceTlsGenerated) }}
       - mountPath: /etc/edm/openshift
         name: edm-openshift-secret
       {{- end }}
{{- end }}
{{- end }}
