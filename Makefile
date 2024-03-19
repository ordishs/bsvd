APPNAME = bsvd
CLINAME = bsvctl
OUTDIR = pkg

# Allow user to override cross compilation scope
OSARCH ?= darwin/386 darwin/amd64 dragonfly/amd64 freebsd/386 freebsd/amd64 freebsd/arm linux/386 linux/amd64 linux/arm netbsd/386 netbsd/amd64 netbsd/arm openbsd/386 openbsd/amd64 plan9/386 plan9/amd64 solaris/amd64 windows/386 windows/amd64
DIRS ?= darwin_386 darwin_amd64 dragonfly_amd64 freebsd_386 freebsd_amd64 freebsd_arm linux_386 linux_amd64 linux_arm netbsd_386 netbsd_amd64 netbsd_arm openbsd_386 openbsd_amd64 plan9_386 plan9_amd64 solaris_amd64 windows_386 windows_amd64

all:
	go build .
	go build ./cmd/bsvctl

compile:
	gox -osarch="$(OSARCH)" -output "$(OUTDIR)/$(APPNAME)-{{.OS}}_{{.Arch}}/$(APPNAME)"
	gox -osarch="$(OSARCH)" -output "$(OUTDIR)/$(APPNAME)-{{.OS}}_{{.Arch}}/$(CLINAME)" ./cmd/bsvctl
	@for dir in $(DIRS) ; do \
		(cp README.md $(OUTDIR)/$(APPNAME)-$$dir/README.md) ;\
		(cp LICENSE $(OUTDIR)/$(APPNAME)-$$dir/LICENSE) ;\
		(cp sample-bsvd.conf $(OUTDIR)/$(APPNAME)-$$dir/sample-bsvd.conf) ;\
		(cd $(OUTDIR) && zip -q $(APPNAME)-$$dir.zip -r $(APPNAME)-$$dir) ;\
		echo "make $(OUTDIR)/$(APPNAME)-$$dir.zip" ;\
	done

install:
	go install .
	go install ./cmd/bsvctl

uninstall:
	go clean -i
	go clean -i ./cmd/bsvctl

docker:
	docker build -t $(APPNAME) .

.PHONY: lint
lint: # todo enable coinbase tracker
	golangci-lint run ./...
	staticcheck ./...

