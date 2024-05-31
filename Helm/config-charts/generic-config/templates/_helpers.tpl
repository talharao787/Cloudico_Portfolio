{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic-config.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains .Values.component .Values.project -}}
{{- printf "%s" .Values.project | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Values.project .Values.component | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "generic-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "generic-config.labels" -}}
{{- $globalScope := index . 0 }}
{{- $componentName := index . 1 -}}
app.kubernetes.io/name: "{{ include "generic-config.fullname" $globalScope }}-config"
helm.sh/chart: {{ include "generic-config.chart" $globalScope | quote }}
app.kubernetes.io/instance: {{ $globalScope.Release.Name | quote }}
app.kubernetes.io/part-of: "{{ include "generic-config.fullname" $globalScope }}-config"
app.kubernetes.io/managed-by: {{ $globalScope.Release.Service | quote }}
app.kubernetes.io/component: {{ $componentName | quote }}
{{- if $globalScope.Chart.AppVersion }}
app.kubernetes.io/version: {{ $globalScope.Chart.AppVersion | quote }}
{{- end -}}
{{- end -}}

{{/*
CloudFlare IP Ranges
*/}}
{{- define "generic-config.cloudflareIpRanges" -}}
173.245.48.0/20
103.21.244.0/22
103.22.200.0/22
103.31.4.0/22
141.101.64.0/18
108.162.192.0/18
190.93.240.0/20
188.114.96.0/20
197.234.240.0/22
198.41.128.0/17
162.158.0.0/15
104.16.0.0/13
104.24.0.0/14
172.64.0.0/13
131.0.72.0/22
2400:cb00::/32
2606:4700::/32
2803:f800::/32
2405:b500::/32
2405:8100::/32
2a06:98c0::/29
2c0f:f248::/32
{{- end -}}

{{/*
Resource naming function
This takes a resource type and a component name as arguments, and includes the component name if it's not already in the release's full name
*/}}
{{- define "generic-config.resourceName" -}}
{{- $globalScope := index . 0 -}}
{{- $resourceType := index . 1 -}}
{{- $componentName := "" -}}
{{- if gt (len .) 2 -}}
{{- $componentName = index . 2 -}}
{{- end -}}

{{- if (contains $componentName (include "generic-config.fullname" $globalScope)) -}}
{{- $componentName = "" -}}
{{- else if contains $globalScope.Values.component $componentName -}}
{{ $componentName = (replace $globalScope.Values.component "" $componentName) }}
{{- end -}}
{{- $stringList := compact (list (include "generic-config.fullname" $globalScope) ($componentName | trimSuffix "-") $resourceType) -}}
{{- join "-" $stringList -}}
{{- end -}}
