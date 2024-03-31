.PHONY: build, install, up

build: web/sites/default/files
	sh -c ". ./env.sh; docker compose build"

install: build
	./cli composer install

up:
	sh -c ". ./env.sh; docker compose up -d"

web/sites/default/files:
	mkdir -p web/sites/default/files
