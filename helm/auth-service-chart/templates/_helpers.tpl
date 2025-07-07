{{/*
Return the base name of the app
*/}}
{{- define "auth-service.name" -}}
auth-service
{{- end }}

{{/*
Return the fully qualified name (eg: <release-name>-auth-service)
*/}}
{{- define "auth-service.fullname" -}}
{{ .Release.Name }}-{{include "auth-service.name" . }}
{{- end }}