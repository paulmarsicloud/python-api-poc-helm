{{- define "python-poc-api-helm.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "python-poc-api-helm.fullname" -}}
{{ .Release.Name }}
{{- end }}
