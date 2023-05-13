.PHONY: build, install

build: web/sites/default/files
	./docker-compose build

web/sites/default/files:
	mkdir -p web/sites/default/files
	chmod o+rw web/sites/default/files

install:
	./composer install
