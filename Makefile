.PHONY: build, install

build: web/sites/default/files
	./docker-compose build

install: build
	./cli composer install

web/sites/default/files:
	mkdir -p web/sites/default/files
