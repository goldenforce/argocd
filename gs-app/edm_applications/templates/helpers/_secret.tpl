{{/*
Create EDM Applications Secret definitions
*/}}
{{- define "secret" -}}
data:
  ### Database Details
  {{- range $v := .Values.database.schemas }}
  DatabaseName_Schema_{{ $v.name }}: {{ $.Values.database.name | b64enc | quote }}
  DatabaseHost_Schema_{{ $v.name }}: {{ $.Values.database.host | b64enc | quote }}
  DatabasePort_Schema_{{ $v.name }}: {{ $.Values.database.port | toString | b64enc }}
  DatabaseService_Schema_{{ $v.name }}: {{ $.Values.database.service | b64enc | quote  }}
  SchemaOwner_{{ $v.name }}: {{ $v.owner | b64enc | quote  }}
  SchemaUser_{{ $v.name }}: {{ $v.user | b64enc | quote  }}
  SchemaPassword_{{ $v.name }}: {{ $v.password | b64enc | quote  }}
  GEMSchemaOwner_{{ $v.name }}: {{ $v.gem.owner | b64enc | quote  }}
  GEMSchemaOwnerPassword_{{ $v.name }}: {{ $v.gem.ownerPassword | b64enc | quote  }}
  GEMSchemaUser_{{ $v.name }}: {{ $v.gem.user | b64enc | quote  }}
  GEMSchemaUserPassword_{{ $v.name }}: {{ $v.gem.userPassword | b64enc | quote  }}
  # Begin - Validations
  # Ensure Database name and Service are same
  {{- if not ( eq $.Values.database.name $.Values.database.service ) }}
  {{- fail (printf "Error: Database Name: %s does not match Database Service: %s" $.Values.database.name $.Values.database.service) }}
  {{- end }}
  #
  # Ensure Owner and GEM owner are same
  {{- if not ( eq $v.owner $v.gem.owner ) }}
  {{- fail (printf "Error: Schema Owner: %s does not match GEM Owner: %s" $v.owner $v.gem.owner) }}
  {{- end }}
  #
  # Ensure User and GEM User are same (non - Repository)
  {{- if not ( eq $v.referenceName "Repository" ) }}
  {{- if not ( eq $v.user $v.gem.user ) }}
  {{- fail (printf "Error: Schema User: %s does not match GEM User: %s" $v.user $v.gem.user) }}
  {{- end }}
  {{- end }}
  # Ensure User and GEM User are same (Repository)
  {{- if ( eq $v.referenceName "Repository" ) }}
  {{- if not ( eq $v.user $v.owner ) }}
  {{- fail (printf "Error: Schema User: %s does not match Schema Owner: %s" $v.user $v.owner) }}
  {{- end }}
  {{- end }}
  #
  # Ensure User Password and GEM User Password are same (non - Repository)
  {{- if not ( eq $v.referenceName "Repository" ) }}
  {{- if not ( eq $v.password $v.gem.userPassword ) }}
  {{- fail (printf "Error: Schema User Password: %s does not match GEM User Password: %s" $v.password $v.gem.userPassword) }}
  {{- end }}
  {{- end }}
  # Ensure User Password and GEM User Password are same (Repository)
  {{- if ( eq $v.referenceName "Repository" ) }}
  {{- if not ( eq $v.password $v.gem.ownerPassword ) }}
  {{- fail (printf "Error: Schema User Password: %s does not match GEM User Password: %s" $v.password $v.gem.ownerPassword) }}
  {{- end }}
  {{- end }}
  #
  # End - Validations
  {{- end }}
  DatabaseOwner_User: {{ $.Values.database.owner.user | b64enc | quote  }} 
  DatabaseOwner_Password: {{ $.Values.database.owner.password | b64enc | quote }}
  
  ### Certificate Details
  Certificate_identityKeyStoreAlias: {{ $.Values.certificates.certificateIdentityKeyStoreAlias | b64enc | quote }}
  Certificate_identityKeyStoreFile: {{ $.Values.certificates.certificateIdentityKeyStoreFile | b64enc | quote }}
  Certificate_identityKeyStoreType: {{ $.Values.certificates.certificateIdentityKeyStoreType | b64enc | quote }}
  Certificate_identityKeyStorePassphrase: {{ $.Values.certificates.certificateIdentityKeyStorePassphrase | b64enc | quote }}
  Certificate_identityKeyStoreDName: {{ $.Values.certificates.certificateIdentityKeyStoreDName | b64enc | quote }}
  Certificate_trustKeyStoreAlias: {{ $.Values.certificates.certificateTrustKeyStoreAlias | b64enc | quote }}
  Certificate_trustKeyStoreFile: {{ $.Values.certificates.certificateTrustKeyStoreFile | b64enc | quote }}
  Certificate_trustKeyStoreType: {{ $.Values.certificates.certificateTrustKeyStoreType | b64enc | quote }}
  Certificate_trustKeyStoreDName: {{ $.Values.certificates.certificateTrustKeyStoreDName | b64enc | quote }}
  Certificate_trustKeyStorePassphrase: {{ $.Values.certificates.certificateTrustKeyStorePassphrase | b64enc | quote }}

  ### Elastic Search 
  Elasticsearch_user: {{ $.Values.subCharts.elasticsearch.credentials.user | b64enc | quote  }}
  Elasticsearch_password: {{ $.Values.subCharts.elasticsearch.credentials.password | b64enc | quote  }}
  Elasticsearch_index: {{ $.Values.subCharts.elasticsearch.index | b64enc | quote  }}

  ### EDM Credentials 
  Service_Account_User: {{ $.Values.deployments.edm.credentials.serviceAccountUser | b64enc | quote  }}
  Service_Account_Password: {{ $.Values.deployments.edm.credentials.serviceAccountPassword | b64enc | quote  }}
  Keycloak_client_secret: {{ $.Values.deployments.edm.credentials.keycloakClientSecret | b64enc | quote  }}
  Keycloak_cookie_secret: {{ $.Values.deployments.edm.credentials.keycloakCookieSecret | b64enc | quote  }}

  ### Docapi credentials
  Docapi_username: {{ $.Values.deployments.edm.credentials.docapiUser | b64enc | quote  }}
  Docapi_password: {{ $.Values.deployments.edm.credentials.docapiPassword | b64enc | quote  }}
  Docapi_client_secret: {{ $.Values.deployments.edm.credentials.docapiClientSecret | b64enc | quote  }}
  
  KEYCLOAK_ADMIN: {{ $.Values.deployments.edm.credentials.keycloakUser | b64enc | quote  }}
  KEYCLOAK_ADMIN_PASSWORD: {{ $.Values.deployments.edm.credentials.keycloakPassword | b64enc | quote  }}

  ### Custom JVM
  {{- range $v := .Values.deployments.edm.customJvm }}
  {{- $customJvm:= split "=" $v }}
  {{ $customJvm._0 }} : {{ $customJvm._1 | b64enc | quote  }}
  {{- end }}

  ### EDM Users/Roles
  {{- range $v := .Values.deployments.edm.usersRoles.users }}
  ApplicationUser_{{ $v.user }}: {{ $v.user | b64enc | quote  }}
  ApplicationPassword_{{ $v.user }}: {{ $v.password | b64enc | quote  }}
  ApplicationRoles_{{ $v.user }}: {{ $v.roles | b64enc | quote  }}
  {{- end }}
stringData:  
  ### Certificates
  {{- $files := .Files }}
  {{- range $path, $_ := .Files.Glob "protected/**" }}
  {{ $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $files.Get (printf "%s" $path) | b64enc | quote }}
  {{ printf "%s_%s" "files" $path | replace "/" "_" | replace "." "_" | replace "-" "_" }}: {{ $path | b64enc | quote }} 
  {{- end }}
{{- end }}
