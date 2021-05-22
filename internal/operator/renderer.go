package operator

import (
	"io"
	"log"
	"text/template"
)

// Renderer defines an interface for a renderer.
type Renderer interface {
	Render(w io.Writer, data interface{})
}

type renderer struct {
	tmpl *template.Template
}

// NewTemplateRenderer is a factory for a TemplateRenderer instance.
func NewTemplateRenderer(pattern string) Renderer {
	tmpl := template.New("template")
	tmpl, err := tmpl.Option("missingkey=error").Parse(pattern)

	if err != nil {
		log.Fatalf("NewTemplateRenderer() could not create template: %v", err)
		return nil
	}

	return &renderer{tmpl}
}

func (r *renderer) Render(w io.Writer, data interface{}) {
	r.tmpl.Execute(w, data)
}
