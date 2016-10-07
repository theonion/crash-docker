FROM python:3.5
MAINTAINER Onion Tech <webtech@theonion.com>

# Grab packages and then cleanup (to minimize image size)
RUN apt-get update && apt-get install -y \
    git-core \
    libmemcached-dev \
    libpq-dev \
    postgresql-client-9.4 \
    vim \
    && curl -sL https://deb.nodesource.com/setup_5.x | bash - && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Deploy-specific python packages
# - Django runs inside uWSGI
# - docker-py required for Docker-assigned ephemeral port detection from within container
RUN pip install "uwsgi>=2.0.11.1,<=2.1" \
                "docker-py==1.4.0"

# Setup app directory
RUN mkdir -p /webapp
WORKDIR /webapp

# Fixed settings we always want (and simplifies uWSGI invocation)
ENV UWSGI_MODULE=crash.wsgi:application \
    UWSGI_MASTER=1 \
    C_FORCE_ROOT=1

ADD requirements/ /webapp/requirements/
RUN pip install -r requirements/dev.txt

ADD crash /webapp
