{{- /* Skip this line */ -}}
|Name|Type|InProgress|Closed|
{{- range .}}
  {{- $issueKey := .Key -}}
  {{- $type := .Fields.Type.Name -}}
  {{- $openToInProgress := false -}}
  {{- $closed := false -}}
  {{- $inProgressDate := "" -}}
  {{- $closedDate := "" -}}
  {{- range .Changelog.Histories -}}
    {{- range .Items -}}
      {{- if and (eq .Field "status") (eq .FromString "Open") (eq .ToString "In Progress") -}}
        {{- $openToInProgress = true -}}
      {{- end -}}
      {{- if and (eq .Field "status") (eq .FromString "In Progress") (eq .ToString "Closed") -}}
        {{- $closed = true -}}
      {{- end -}}
      {{- if and (eq .Field "status") (eq .FromString "In Review") (eq .ToString "Closed") -}}
        {{- $closed = true -}}
      {{- end -}}
    {{- end -}}
    {{- if $openToInProgress -}}
        {{- $inProgressDate = .Created -}}
    {{- end -}}
    {{- if $closed -}}
        {{- $closedDate = .Created -}}
    {{- end -}}
  {{- end -}}
{{- if $openToInProgress }}
|{{ $issueKey }}|{{ $type }}|{{ $inProgressDate }}|{{ $closedDate }}|
{{- end }}
{{- end }}
