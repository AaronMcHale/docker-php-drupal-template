.PHONY: build

build: composer.lock vendor web
	sh docker/build.sh

composer.lock:
	echo "{}" > composer.lock

vendor:
	mkdir vendor

web:
	mkdir web
