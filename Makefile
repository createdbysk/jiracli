WHICH=command -v
GO=$(shell which go)
ARTIFACT=$(shell basename $(PWD))
BUILD_DIR=build
REPO_BASE_URL=https://gitlab.com/createdbysk/jiracli
REF=1

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
foo:
	echo $(GO)
	echo $(GOLINT)

check: test fmt-check vet lint staticcheck

test:
	$(GO) test ./...

coverage:
	mkdir -p $(BUILD_DIR)/coverage
	$(GO) test -race -coverprofile=$(BUILD_DIR)/coverage/coverage.txt -covermode=atomic ./...
	$(GO) tool cover -func $(BUILD_DIR)/coverage/coverage.txt

coverage-html:
	mkdir -p $(BUILD_DIR)/coverage
	$(GO) test -race -coverprofile=$(BUILD_DIR)/coverage/coverage.txt -covermode=atomic ./...
	$(GO) tool cover -html $(BUILD_DIR)/coverage/coverage.txt

$(BUILD_DIR)/coverage/coverage.txt: coverage

coverage-cobertura: $(BUILD_DIR)/coverage/coverage.txt
	$(WHICH) gocover-cobertura || ($(GO) get github.com/boumenot/gocover-cobertura && go mod tidy)
	$(GOPATH)/$(BUILD_DIR)/gocover-cobertura < $(BUILD_DIR)/coverage/coverage.txt > $(BUILD_DIR)/coverage/cobertura.xml

# Lint/formatting targets

fmt:
	$(GO) fmt ./...

fmt-check:
	test -z "$(shell gofmt -l .)"

vet:
	$(GO) vet ./...

lint:
	$(WHICH) golint || ($(GO) get golang.org/x/lint/golint  && go mod tidy)
	$(GO) list ./... | grep -v /vendor/ | grep -v docs | xargs -L1 $(GOPATH)/$(BUILD_DIR)/golint -set_exit_status

staticcheck:
	$(WHICH) staticcheck || ($(GO) get honnef.co/go/tools/cmd/staticcheck && go mod tidy)
	rm -rf $(BUILD_DIR)/staticcheck
	mkdir -p $(BUILD_DIR)/staticcheck
	ln -s "$(GO)" $(BUILD_DIR)/staticcheck/go
	PATH="$(PWD)/$(BUILD_DIR)/staticcheck:$(PATH)" $(GOPATH)/$(BUILD_DIR)/staticcheck ./...
	rm -rf $(BUILD_DIR)/staticcheck

# Building targets
build: clean
	mkdir -p $(BUILD_DIR)/
	@echo Building with $(shell $(GO) version)
	$(GO) get -d -v ./...
	# Create static binaries
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GO) build -o $(BUILD_DIR)/$(ARTIFACT)

clean:
	rm -rf $(BUILD_DIR)

# Go Source-Code Documentation
godoc:
	$(WHICH) godoc || { $(GO) get -v golang.org/x/tools/cmd/godoc && $(GO) mod tidy; }
	$(GOPATH)/$(BUILD_DIR)/godoc -http=:58080 -index

download:
	mkdir -p ${BUILD_DIR}
	curl -L -o ${BUILD_DIR}/jiracli.zip $(REPO_BASE_URL)/-/jobs/artifacts/$(REF)/download?job=publish
	unzip ${BUILD_DIR}/jiracli.zip
