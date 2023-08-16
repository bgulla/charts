{{/* Define the name of the application */}}
{{- define "rancher-demo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define the fullname which includes the release name */}}
{{- define "rancher-demo.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "rancher-demo.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Generate standard labels */}}
{{- define "rancher-demo.labels" -}}
app.kubernetes.io/name: {{ include "rancher-demo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ include "rancher-demo.chart" . }}
{{- if .Values.customLabels -}}
{{- toYaml .Values.customLabels | nindent 4 }}
{{- end -}}
{{- end -}}

{{/* Helper to generate chart label */}}
{{- define "rancher-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Custom annotations */}}
{{- define "rancher-demo.annotations" -}}
{{- if .Values.customAnnotations -}}
{{- toYaml .Values.customAnnotations | nindent 4 }}
{{- end -}}
{{- end -}}
