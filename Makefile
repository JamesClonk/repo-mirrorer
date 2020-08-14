.DEFAULT_GOAL := help
SHELL := /bin/bash
APP ?= $(shell basename $$(pwd))
COMMIT_SHA = $(shell git rev-parse HEAD)

.PHONY: help
## help: prints this help message
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: login
## login: login to docker hub
login:
	@export PATH="$$HOME/bin:$$PATH"
	@echo $$DOCKER_PASS | docker login -u $$DOCKER_USER --password-stdin

.PHONY: build
## build: build docker image
build:
	@export PATH="$$HOME/bin:$$PATH"
	docker build -t jamesclonk/${APP}:${COMMIT_SHA} .

.PHONY: push
## push: build and push docker image
push: build
	@export PATH="$$HOME/bin:$$PATH"
	docker push jamesclonk/${APP}:${COMMIT_SHA}
	docker tag jamesclonk/${APP}:${COMMIT_SHA} jamesclonk/${APP}:latest
	docker push jamesclonk/${APP}:latest

.PHONY: run
## run: run docker image
run:
	@export PATH="$$HOME/bin:$$PATH"
	docker run --rm jamesclonk/${APP}:${COMMIT_SHA}
