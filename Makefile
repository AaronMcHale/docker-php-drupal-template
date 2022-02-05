.PHONY: build

build: composer.lock vendor web web/sites/default/files
	sh docker/build.sh

composer.lock:
	echo "{}" > composer.lock

vendor:
	mkdir vendor

web:
	mkdir web

web/sites/default/files:
	mkdir -p web/sites/default/files
	chmod o+rw web/sites/default/files
