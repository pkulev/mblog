# Common variables
PROJ=MicroBlojeeq
VENV=virtualenv --python=python3

# Production environment
PROJ_USER=_mblog
PROJ_HOME=/home/${PROJ_USER}
PROJ_DIST=`pwd`/*
PROJ_GROUP=_mblog
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
MKDIR=mkdir -p
CHOWN=chown
CHMOD=chmod
SUWRAP=sudo -u ${PROJ_USER}
USERADD=adduser -g ${PROJ_GROUP} ${PROJ_USER}
USERDEL=userdel -rf ${PROJ_USER}


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
	@printf "\n\nUse following command to activate virtual environment:\n"
	@printf "source ${DEV_ENV}/bin/activate\n"
	@printf "uwsgi --http 0.0.0.0:8080 --wsgi-file run.py --callable app --master\n"

clean:
	@printf "========== Removing old environment ==========\n"
	${RM} ${DEV_ENV}
	${RM} ${PROJ}.egg-info
	${RM} __pycache__
	${RM} *~ \#*
	${RM} ${PROJ_MAKEFILE}


install_production_environment: clean install_deps generate_prod_makefile
	@printf "========== Deploying prod environment ==========\n"
	sudo groupadd ${PROJ_GROUP}
	sudo ${USERADD}
	sudo ${CP} ${PROJ_DIST} ${PROJ_HOME}
	sudo ${CHOWN} -R ${PROJ_USER}:${PROJ_GROUP} ${PROJ_HOME}
	sudo ${MKDIR} /etc/mblog
#	sudo ${MKDIR} /var/run/mblog
	sudo ${MKDIR} /var/log/mblog
	sudo ${MKDIR} /var/run/lock/mblog
#	sudo ${CHOWN} ${PROJ_USER}:${PROJ_GROUP} /var/run/lock/mblog
	sudo ${CHOWN} ${PROJ_USER}:${PROJ_GROUP} /var/log/mblog
	sudo ${CHOWN} ${PROJ_USER}:${PROJ_GROUP} /var/run/lock/mblog
	sudo ${CP} ${PROJ_HOME}/mblog-uwsgi.ini /etc/mblog/
	sudo ${CP} ${PROJ_HOME}/mblog-nginx.conf /etc/nginx/conf.d/
	sudo ${CP} ${PROJ_HOME}/mblogd /etc/init.d/
	sudo ${CHMOD} +x /etc/init.d/mblogd
	sudo chkconfig --add mblogd
	sudo chkconfig mblogd on
	${SUWRAP} ${MAKE} -C ${PROJ_HOME} -f ${PROJ_HOME}/Makefile.prod install
	@printf "\n\nUse following commands to start service:\n"
	@printf "sudo service mongod start\n"
	@printf "sudo service mblogd start\n"
	@printf "sudo service nginx start\n"
	@printf "test with curl localhost\n"
	@printf "\n\nUse following commands to activate virtual environment:\n"
	@printf "sudo su ${PROJ_USER}\n"
	@printf "cd ${PROJ_HOME}\n"
	@printf "source ${PROJ_ENV}/bin/activate\n"


install_deps:
	@printf "========== Installing dependencies ==========\n"
	sudo yum install nginx python3 python3-pip python3-devel mongodb-server mongodb
	sudo pip install virtualenv

generate_prod_makefile:
	@echo "install:"                                        >  ${PROJ_MAKEFILE}
	@echo "	${VENV} ${PROJ_ENV}"                            >> ${PROJ_MAKEFILE}
	@echo "	${PROJ_PIP} install --upgrade pip"              >> ${PROJ_MAKEFILE}
	@echo "	${PROJ_PYTHON} ${PROJ_HOME}/setup.py install"   >> ${PROJ_MAKEFILE}


remove_production_environment:
	@printf "========== Removing production environment ==========\n"
	sudo ${USERDEL}
#	sudo groupdel ${PROJ_GROUP}
	sudo ${RM} /etc/mblog
	sudo ${RM} /etc/nginx/conf.d/mblog-nginx.conf
	sudo ${RM} /etc/init.d/mblogd
#	sudo ${RM} /var/run/mblog
	sudo ${RM} /var/log/mblog
	sudo ${RM} /var/run/lock/mblog
	@printf "Omitting system packages removal, use make remove_deps:\n"
	@printf "nginx python3{-devel,-pip} mongodb{,-server} virtualenv\n"

remove_deps:
	@printf "========== Removing dependencies ==========\n"
	@printf "THIS IS VERY DESTRUCTIVE OPERATION. RUN make remove_deps by root.\n"
	@printf "Packages for removal: nginx python3{-deve;,-pip} virtualenv\n"
	yum remove nginx python3 python3-devel python3-pip mongodb mongodb-server
	pip uninstall virtualenv

generate_nginx_config:


.PHONY: all help devel install_deps clean install_production_environment remove_production_environment
