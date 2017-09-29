RELEASE=v1.0.0
VERSION="main.Version=$(RELEASE)"
BUILDSTAMP="main.Buildstamp=$(shell date -u '+%Y-%m-%dT%I:%M%p')"
GIT_HASH="main.Githash=$(shell git rev-parse HEAD)"
LDFLAGS=-ldflags "-X $(VERSION) -X $(BUILDSTAMP) -X $(GIT_HASH)"
GOOS ?= darwin
GOARCH ?= amd64
PROG=out/servdir_$(RELEASE)_$(GOOS)_$(GOARCH)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deps
deps: ## install dependencies (there is only dev dependencies)
	go get github.com/alecthomas/gometalinter

.PHONY: install
install: ## installs the prog
	go install $(LDFLAGS)

.PHONY: check
check: ## runs linter on the code
	gofmt -l -s -w .
	gometalinter ./... --deadline=45s --vendor

release: clean check ## creates a release
	GOOS=darwin  GOARCH=amd64  go build $(LDFLAGS) -o out/servdir_$(RELEASE)_darwin_amd64
	GOOS=linux   GOARCH=arm    go build $(LDFLAGS) -o out/servdir_$(RELEASE)_linux_arm
	GOOS=windows GOARCH=amd64  go build $(LDFLAGS) -o out/servdir_$(RELEASE)_windows_amd64

log: ## shows git log
	@git log --graph --oneline --decorate

clean:
	rm -rf ./out
