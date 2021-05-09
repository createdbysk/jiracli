// Package testutils provides utilities for tests to use.
package testutils

import (
	"io"
	"os"
	"regexp"
	"strings"
)

// CaptureStdout replaces os.Stdout with a writer that buffers any data written
// to os.Stdout. Call the returned function to cleanup and get the data
// as a string.
func CaptureStdout() func() (string, error) {
	r, w, err := os.Pipe()
	if err != nil {
		panic(err)
	}

	done := make(chan error, 1)

	save := os.Stdout
	os.Stdout = w

	var buf strings.Builder

	go func() {
		_, err := io.Copy(&buf, r)
		r.Close()
		done <- err
	}()

	return func() (string, error) {
		os.Stdout = save
		w.Close()
		err := <-done
		return buf.String(), err
	}
}

// RemoveWhitespace removes all whitespace from a string.
//
// An example use of this function is to compare two strings
// independent of whitespaces.
func RemoveWhitespace(str string) string {
	pattern := regexp.MustCompile(`\s+`)
	return pattern.ReplaceAllString(str, "")
}
