package testutils

import "reflect"

// GetFnPtr is a test utility to get function pointer represented as an uintptr.
func GetFnPtr(fn interface{}) uintptr {
	return reflect.ValueOf(fn).Pointer()
}
