SHELL := /bin/bash
PROJECT_NAME = mfratadotcom

DOCKER_IMG := $(PROJECT_NAME):latest
DOCKER_RUN := docker run --rm -t
USER := -e USER_ID="$(shell id -u $$USER)" -e GROUP_ID="$(shell id -g $$USER)"

MOUNT := \
	-v $(PWD)/pages:/usr/src/app/pages \
	-v $(PWD)/public:/usr/src/app/public \
	-v $(PWD)/scripts:/usr/src/app/scripts \
	-v $(PWD)/styles:/usr/src/app/styles \
	-v $(PROJECT_NAME):/usr/src/app

# Source https://gist.github.com/coryodaniel/5fb5503953ca799cd51adc6764324780
help: ## Print this beautiful help
	@grep -E '^[a-zA-Z_0-9-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Clean the image
	docker rmi $(DOCKER_IMG) --force

build: ## Build an image to run tests and linter
	docker build -t $(DOCKER_IMG) .

shell: build  ## Opens a shell to interact inside the container
	$(DOCKER_RUN) -i -p 3000:3000 $(MOUNT) $(DOCKER_IMG) bash

run: build  ## Runs the website with auto reloading
	$(DOCKER_RUN) -i -p 3000:3000 $(MOUNT) $(DOCKER_IMG) npm run-script dev
