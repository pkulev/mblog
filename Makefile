# Common variables
PROJ=MicroBlojeeq
VENV=virtualenv --python=python3

# Production environment
PROJ_USER=_mblog
PROJ_HOME=/home/${PROJ_USER}
PROJ_DIST=`pwd`/*
PROJ_WS_GROUP=nginx
PROJ_ENV=${PROJ_HOME}/env
PROJ_PYTHON=${PROJ_ENV}/bin/python3
PROJ_PIP=${PROJ_ENV}/bin/pip3
PROJ_MAKEFILE=./Makefile.prod

# Development environment
DEV_ENV=./env
DEV_PYTHON=${DEV_ENV}/bin/python3 # UNUSED
DEV_PIP=${DEV_ENV}/bin/pip3

# Commands
CP=cp -rf
RM=rm -rf
SUWRAP=sudo -u ${PROJ_USER}
USERADD=adduser -g ${PROJ_WS_GROUP} ${PROJ_USER}
USERDEL=userdel -rf ${PROJ_USER}
CHOWN_HOME=chown -R ${PROJ_USER}:${PROJ_WS_GROUP} ${PROJ_HOME}


all: help

help:
	@printf "USAGE: make {help | clean | install_deps | devel | install | {install|remove}_production_environment}\n"
	@printf "OPTIONS: \n"
	@printf "        help                                 print this message;\n"
	@printf "        clean                                remove venv and builds;\n"
	@printf "        devel                                deploy development environment;\n"
	@printf "        install_deps                         install dependencies;\n"
	@printf "        remove_production_environment        remove production;\n"
	@printf "        install_production_environment       deploy production.\n"


devel: clean
	@printf "========== Deploying devel environment ==========\n"
	@printf "Install (nginx, virtualenv) system packages by make install_deps.\n"
	${VENV} ${DEV_ENV}
	${DEV_PIP} install --upgrade pip
	${DEV_PIP} install --editable .
	@printf "Use following command to activate virtual environment:\n"
	@printf "source ${DEV_ENV}/bin/activate\n"

clean:
	@printf "========== Removing old environment ==========\n"
	${RM} ${DEV_ENV}
	${RM} ${PROJ}.egg-info
	${RM} __pycache__
	${RM} *~ \#*


install_production_environment: clean install_deps generate_prod_makefile
	@printf "========== Deploying prod environment ==========\n"
	sudo ${USERADD}
	sudo ${CP} ${PROJ_DIST} ${PROJ_HOME}
	sudo ${CHOWN_HOME}
	${SUWRAP} ${MAKE} -C ${PROJ_HOME} -f ${PROJ_HOME}/Makefile.prod install
	@printf "\n\nUse following command to activate virtual environment:\n"
	@printf "sudo su ${PROJ_USER}\n"
	@printf "cd ${PROJ_HOME}\n"
	@printf "source ${PROJ_ENV}/bin/activate\n"

install_deps:
	@printf "========== Installing dependencies ==========\n"
	sudo yum install nginx
	sudo pip install virtualenv

generate_prod_makefile:
	@echo "install:"                                        >  ${PROJ_MAKEFILE}
	@echo "	${VENV} ${PROJ_ENV}"                            >> ${PROJ_MAKEFILE}
	@echo "	${PROJ_PIP} install --upgrade pip"              >> ${PROJ_MAKEFILE}
	@echo "	${PROJ_PYTHON} ${PROJ_HOME}/setup.py install"   >> ${PROJ_MAKEFILE}


remove_production_environment:
	@printf "========== Removing production environment ==========\n"
	sudo ${USERDEL}
	@printf "Omitting system packages removal, use make remove_deps.\n"
	@printf "Omitting webserver removal (UWSGI, NGINX)...\n"
	@printf "Omitting virtualenv removal...\n"

remove_deps:
	@printf "========== Removing dependencies ==========\n"
	sudo yum remove nginx
	sudo pip uninstall virtualenv


.PHONY: all help devel install_deps clean install_production_environment remove_production_environment
