#!/bin/bash

pwd
python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py loaddata fixtures/initial_data.json

# sleep 30
uwsgi --ini uwsgi.ini
