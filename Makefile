# Common variables
PROJ=MicroBlojeeq
VENV=virtualenv --python=python3

# Production environment
PROJ_USER=_mblog
PROJ_HOME=/home/${PROJ_USER}
PROJ_WS_GROUP=nginx
PROJ_ENV=${PROJ_HOME}/env
PROJ_PYTHON=${PROJ_ENV}/bin/python3
PROJ_PIP=${PROJ_ENV}/bin/pip3

# Development environment
DEV_ENV=./env
DEV_PYTHON=${DEV_ENV}/bin/python3
DEV_PIP=${DEV_ENV}/bin/pip3

# Commands
RM=rm -rf
USERADD=adduser -g ${PROJ_WS_GROUP} ${PROJ_USER}
USERDEL=userdel -rf ${PROJ_USER}

all: help

help:
	@printf "USAGE: make [help] [clean] [install_deps] {devel | install}\n"
	@printf "OPTIONS: \n"
	@printf "        help          print this message;\n"
	@printf "        clean         remove venv and builds;\n"
	@printf "        devel         deploy development environment;\n"
	@printf "        install       deploy production;\n"
	@printf "        install_deps  install dependencies.\n"

devel: clean
	@printf "========== Deploying devel environment ==========\n"
	@printf "install (nginx, ) system packages by make install_deps.\n"
	${VENV} ${DEV_ENV}
	${DEV_PIP} install --upgrade pip
	${DEV_PIP} install --editable .
	@printf "Use following command to activate virtual environment:\n"
	@printf "source ${DEV_ENV}/bin/activate\n"

install_production_environment: clean install_deps
	@printf "========== Deploying prod environment ==========\n"
	sudo ${USERADD}
	sudo -u ${PROJ_USER} ${VENV} ${PROJ_ENV}
	sudo -u ${PROJ_USER} ${PROJ_PIP} isntall --upgrade pip
	sudo -u ${PROJ_USER} ${PROJ_PYTHON} setup.py install
	@printf "Use following command to activate virtual environment:\n"
	@printf "source ${PROJ_ENV}/bin/activate\n"


install_deps:
	@printf "========== Installing dependencies ==========\n"
	sudo yum install nginx
	sudo pip install virtualenv

clean:
	@printf "========== Removing old environment ==========\n"
	${RM} ${ENV}
	${RM} ${PROJ}.egg-info
	${RM} __pycache__
	${RM} *~ \#*

remove_production_environment:
	@printf "========== Removing production environment ==========\n"
	sudo ${USERDEL}
	@printf "Omitting webserver removing (UWSGI, NGINX)...\n"

.PHONY: all help devel install install_deps clean remove_production_environment
