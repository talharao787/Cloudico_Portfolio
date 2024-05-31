{{/*
Expand the name of the chart.
*/}}
{{- define "generic-app.name" -}}
{{- default "%s" .Values.project | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic-app.fullname" -}}
{{- $globalScope := index . 0 }}
{{- $componentName := index . 1 }}
{{- if $globalScope.Values.fullnameOverride -}}
{{- $globalScope.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains $componentName $globalScope.Values.project -}}
{{- printf "%s-%s" $globalScope.Values.project $globalScope.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" $globalScope.Values.project $componentName $globalScope.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "generic-app.chart" -}}
{{- printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "generic-app.labels" -}}
app.kubernetes.io/name: {{ include "generic-app.name" $ | quote }}
helm.sh/chart: {{ printf "%s-%s" "generic-app" .Chart.Version | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/part-of: {{ .Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}
