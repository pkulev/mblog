PROJ=MicroBlojeeq

VENV=virtualenv
ENV=./env
PYTHON=${ENV}/bin/python3
PIP=${ENV}/bin/pip3

RM=rm -rf

all: help

help:
	@printf "USAGE: make [help] [clean] {devel | install}\n"
	@printf "OPTIONS: \n"
	@printf "        help       print this message;\n"
	@printf "        clean      remove venv and builds;\n"
	@printf "        devel      deploy development environment;\n"
	@printf "        install    deploy production.\n"

devel: clean
	@printf "Deploying\n"
	${VENV} ${ENV}
	${PIP} install --editable .
	@printf "Use following command to activate virtual environment:\n"
	@printf "source ${ENV}/bin/activate\n"

install: clean
	@printf "Prod deploying\n"

clean:
	@printf "Removing old environment\n"
	${RM} ${ENV}
	${RM} ${PROJ}.egg-info
	${RM} __pycache__

.PHONY: help, clean
