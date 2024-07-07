FROM python:3.9-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /code

COPY requirements.txt /code/

RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && pip install https://projects.unbit.it/downloads/uwsgi-lts.tar.gz



COPY polls/ /code/
# RUN python manage.py collectstatic --noinput

# Run migrations and load initial data (optional, can be done at runtime)
# RUN python manage.py makemigrations
# RUN python manage.py migrate
# RUN python manage.py loaddata fixtures/initial_data.json

# Expose the port on which the app runs
EXPOSE 8000

# CMD ["uwsgi", "--ini", "uwsgi.ini"]
# CMD ["bash", "-c", "./start.sh"]
CMD ["./start.sh"]
# CMD ["tail", "-f", "/dev/null"]
