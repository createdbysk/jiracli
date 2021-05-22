package operator

// Query defines an interface to queries.
type Query interface {
	Get(result interface{}) error
}

// Connection defines an interface to connections.
type Connection interface {
	Execute(q Query, data interface{})
}
