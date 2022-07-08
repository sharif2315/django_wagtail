#!/bin/bash

. /opt/sw/pyenv/bin/activate

cd /app || exit
python manage.py migrate
python manage.py collectstatic --noinput

chown -R apache:apache /app

/usr/sbin/apachectl "$@"
