.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deps
deps: ## install dependencies (there is only dev dependencies)
	go get github.com/alecthomas/gometalinter
	go get github.com/goreleaser/goreleaser

.PHONY: install
install: ## installs the prog
	go install $(LDFLAGS)

.PHONY: check
check: ## runs linter on the code
	gofmt -l -s -w .
	gometalinter ./... --deadline=45s --vendor

release: clean check ## creates a release
	goreleaser

log: ## shows git log
	@git log --graph --oneline --decorate

clean:
	rm -rf ./out
