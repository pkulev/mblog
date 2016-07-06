FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
	mongodb-server \
	nginx \
	python3-pip \
&& rm -rf /var/lib/apt/lists/*

RUN pip3 install virtualenv

COPY ./ /usr/share/mblog
WORKDIR /usr/share/mblog

RUN virtualenv --python=python3 .venv
RUN .venv/bin/pip3 install -r requirements.txt

RUN mv mblog-nginx.conf /etc/nginx/conf.d
RUN service nginx reload

EXPOSE 8080

CMD [".venv/bin/python3", "run.py", "runserver", "-h", "0.0.0.0", "-p", "8080"]
