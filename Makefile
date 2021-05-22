GO=$(shell which go)
ARTIFACT=jiracli

.PHONY: help clean test coverage coverage-html fmt fmt-check vet lint staticcheck godoc

help:
	@echo "Test/check:"
	@echo "  make test                        - Run tests"
	@echo "  make coverage                    - Run tests and show coverage"
	@echo "  make coverage-html               - Run tests and show coverage (as HTML)"
	@echo "  make coverage-upload             - Upload coverage results to codecov.io"
	@echo
	@echo "Lint/format:"
	@echo "  make fmt                         - Run 'go fmt'"
	@echo "  make fmt-check                   - Run 'go fmt', but don't change anything"
	@echo "  make vet                         - Run 'go vet'"
	@echo "  make lint                        - Run 'golint'"
	@echo "  make staticcheck                 - Run 'staticcheck'"
	@echo
	@echo "Build:"
	@echo "  make build                       - Build"
	@echo "  make clean                       - Clean build folder"
	@echo
	@echo "Source Code Documentation"
	@echo "  make godoc                       - Builds the source code documentation and serves it on port 6060"

# Test/check targets

check: test fmt-check vet lint staticcheck

test:
	$(GO) test ./...

coverage:
	mkdir -p build/coverage
	$(GO) test -race -coverprofile=build/coverage/coverage.txt -covermode=atomic ./...
	$(GO) tool cover -func build/coverage/coverage.txt

coverage-html:
	mkdir -p build/coverage
	$(GO) test -race -coverprofile=build/coverage/coverage.txt -covermode=atomic ./...
	$(GO) tool cover -html build/coverage/coverage.txt

# Lint/formatting targets

fmt:
	$(GO) fmt ./...

fmt-check:
	test -z "$(shell gofmt -l .)"

vet:
	$(GO) vet ./...

lint:
	which golint || ($(GO) get golang.org/x/lint/golint  && go mod tidy)
	$(GO) list ./... | grep -v /vendor/ | grep -v docs | xargs -L1 golint -set_exit_status

staticcheck:
	which staticcheck || ($(GO) get honnef.co/go/tools/cmd/staticcheck && go mod tidy)
	rm -rf build/staticcheck
	mkdir -p build/staticcheck
	ln -s "$(GO)" build/staticcheck/go
	PATH="$(PWD)/build/staticcheck:$(PATH)" staticcheck ./...
	rm -rf build/staticcheck

# Building targets

build: clean
	mkdir -p bin/
	@echo Building with $(shell $(GO) version)
	$(GO) get -d -v ./...
	$(GO) build -o bin/$(ARTIFACT)

clean:
	rm -rf bin build
