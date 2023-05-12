.PHONY: build

build: web/sites/default/files
	sh docker/build.sh

web/sites/default/files:
	mkdir -p web/sites/default/files
	chmod o+rw web/sites/default/files
