build: composer.lock vendor web
	./docker/build.sh

composer.lock:
	echo "{}" > composer.lock

vendor:
	mkdir vendor

web:
	mkdir web
