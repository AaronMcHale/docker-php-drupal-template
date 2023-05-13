.PHONY: build, install

build: web/sites/default/files
	./docker-compose build

install:
	./composer install
