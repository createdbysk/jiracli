package operator

// MockConnection provides a mock implementation for Connection.
type MockConnection struct{}

// Execute implements the Execute() method of MockConnection.
func (c *MockConnection) Execute(q Query, data interface{}) {}

// MockQuery provides a mock implementation for Query.
type MockQuery struct{}

// Get implements the Get() method of MockQuery.
func (q *MockQuery) Get(result interface{}) error {
	return nil
}
