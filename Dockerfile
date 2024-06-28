FROM python:3.9-alpine3.13

LABEL maintainer="remingtonsteele"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app 
WORKDIR /app

EXPOSE 8000

ARG DEV=false

# create venv called py
RUN python -m venv /py && \
    # upgrade venv's pip
    /py/bin/pip install --upgrade pip && \
    # install requirements.txt into venv
    /py/bin/pip install -r /tmp/requirements.txt && \
    # if running from docker-compose, will install dev reqirements
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # remove temp directory
    rm -rf /tmp && \
    # adds user in image (not root user)
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# define path to venv
ENV PATH="/py/bin:$PATH"

# defines user
USER django-user