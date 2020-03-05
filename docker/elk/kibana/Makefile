SHELL=/bin/bash
ELASTIC_REGISTRY ?= lizhiyong2000
IMAGE_TAG ?= $(ELASTIC_REGISTRY)/kibana
HTTPD ?= kibana-docker-artifact-server

ARTIFACTS_DIR ?= /home/lizhiyong/Downloads

export PATH := ./build:./venv/bin:$(PATH)

# Determine the version to build. Override by setting ELASTIC_VERSION env var.
ELASTIC_VERSION := 6.3.0


VERSION_TAG=$(ELASTIC_VERSION)

PYTHON ?= $(shell command -v python3.5 || command -v python3.6)

FIGLET := pyfiglet -w 160 -f puffy

all: build test

test: lint
	  $(FIGLET) "test"; \
	  ./build/pytest tests; \

lint: venv
	  flake8 tests

build:
	  $(FIGLET) "build"; \
	  docker build -t $(IMAGE_TAG):$(VERSION_TAG) \
	    -f Dockerfile .; \

# Build from artifacts on the local filesystem, using an http server (running
# in a container) to provide the artifacts to the Dockerfile.
build-local: venv
	docker run --rm -d --name=$(HTTPD) \
	           --network=host -v $(ARTIFACTS_DIR):/mnt \
	           python:3 bash -c 'cd /mnt && python3 -m http.server'
	timeout 120 bash -c 'until curl -s localhost:8000 > /dev/null; do sleep 1; done'
	pyfiglet -f puffy -w 160 "Building: "; \
	docker build --network=host -t $(IMAGE_TAG):$(VERSION_TAG) -f Dockerfile . || \
	docker kill $(HTTPD) 
	-docker kill $(HTTPD)


# Push the image to the dedicated push endpoint at "push.docker.elastic.co"
push: test
	docker push $(IMAGE_TAG):$(VERSION_TAG); 

clean-test:
	$(TEST_COMPOSE) down
	$(TEST_COMPOSE) rm --force

venv:
	test -d venv || virtualenv --python=$(PYTHON) venv
	pip install -r build/requirements.txt
	touch venv

.PHONY: build clean flake8 push pytest test 
