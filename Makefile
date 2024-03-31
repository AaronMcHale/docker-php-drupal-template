.PHONY: build, install, up

build: web/sites/default/files
	sh -- . ./env.sh && docker compose build

install: build
	sh -- . ./env.sh && ./cli composer install

up:
	sh -- . ./env.sh && docker compose up -d

web/sites/default/files:
	mkdir -p web/sites/default/files
