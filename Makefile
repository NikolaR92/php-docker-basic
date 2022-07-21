DC=docker-compose
CONTAINER_PHP=php
CONTAINER_NODE=node
RUN_PHP_COMMAND=$(DC) run --rm $(CONTAINER_PHP)
RUN_NODE_COMMAND=$(DC) run $(CONTAINER_NODE)
EXEC_PHP_COMMAND=$(DC) exec $(CONTAINER_PHP)
BASH=/bin/bash
CONSOLE=bin/console
PACKAGE_MANAGER=yarn
ADD_NODE_PACKAGE=yarn add
INSTALL_NODE_PACKAGE=yarn install

##
##  Project setup
##-----------------------------------------------------------

.PHONY: install

##  install :Install project
install: start wait composer-install node-install

##
## Docker
##------------------------------------------------------------
.PHONY: up start stop remove

## pull     : Pull the latest images
pull:
	$(DC) pull

## start    : Alias to up
start: up

## up       : Mount the container
up:
	@$(DC) up -d

## stop     : Stop container without deleting
stop:
	@$(DC) stop

## remove  : Stops, remove the containers and their volumes
remove:
	@$(DC) down -v --remove-orphans

##
## Database
##--------------------------------------------------------


##
## Tools
##-------------------------------------------------------
.PHONY: wait cc bash composer-install composer-require node-install node-add-package node-compile node-watch

## wait    : Wait for 1 minutes
wait:
	@echo "Waiting for container to be healthy"
	@$(RUN_PHP_COMMAND) sleep 1m

## cc      : Clear and warm up the cache in dev env
cc:
	@$(EXEC_PHP_COMMAND) $(CONSOLE) cache:clear --no-warmup
	@$(EXEC_PHP_COMMAND) $(CONSOLE) cache:warmup

## bash : Access the php container via shell
bash:
	@$(EXEC_PHP_COMMAND) bash

## composer-install : Execute composer install command in container
composer-install:
	@$(EXEC_PHP_COMMAND) ".composer.phar install --no-scripts --no-suggest -o"

## composer-require: Add a new php package variable "package"
composer-require:
	@$(EXEC_PHP_COMMAND) bash -c "./composer.phar require ${package}"

## node-install  : Execute node install command in container
node-install:
	@$(RUN_NODE_COMMAND) $(INSTALL_NODE_PACKAGE)

## node-add-package : Execute node add command in container variables "package" and "env"
node-add-package:
	@$(RUN_NODE_COMMAND) $(ADD_NODE_PACKAGE) ${package} ${env}

## node-compile  : Compiles javascript and css
node-compile:
	@$(RUN_NODE_COMMAND) $(PACKAGE_MANAGER) dev

## node-watch : Watch changes to javascript and css and compile
node-watch:
	@$(RUN_NODE_COMMAND) $(PACKAGE_MANAGER) watch
