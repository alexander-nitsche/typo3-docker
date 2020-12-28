SHELL := /bin/bash

-include .env
BRANCH ?= $$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

.PHONY: check build install start stop

check:
	@if [ ! -f ".env" ]; then \
		echo "Missing environment file. Copy .env-template to .env and adapt." && exit 1; \
	fi;

build: check
	@echo "Build TYPO3 Docker images for project $(PROJECTNAME) [branch: $(BRANCH)]"
	@docker-compose -f dev.yml build --force-rm

install: check
	@echo "Install TYPO3 in project $(PROJECTNAME)"
	@mkdir -p typo3
	@docker-compose -f admin.yml run --rm install-typo3-composer

start: check
	@echo "Bring up TYPO3 project $(PROJECTNAME) [branch: $(BRANCH)]"
	@docker-compose -f dev.yml up

stop:
	@echo "Bring down TYPO3 project $(PROJECTNAME)"
	@docker-compose -f dev.yml down
