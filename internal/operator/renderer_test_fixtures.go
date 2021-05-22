package operator

import "io"

// MockRenderer provies a mock implementation of the Renderer interface.
type MockRenderer struct{}

// Render provides a mock implementation of the Render function of a Renderer.
func (r *MockRenderer) Render(w io.Writer, data interface{}) {}
