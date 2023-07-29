FROM python:3.8-slim-buster

RUN mkdir /app
WORKDIR app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y build-essential libpq-dev

RUN rm -rf /var/lib/apr/lists/*
COPY . .
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

CMD python3 manage.py makemigrations --noinput && \
    python3 manage.py migrate --noinput && \
    python3 manage.py collectstatic --noinput && \
    python3 manage.py createsuperuser --user admin --emial admin@localhost --noinput; \
    gunicorn -b 0.0.0.0:8000 test02.wsgi