FROM python:3.10-slim-bullseye

# Fix old bullseye security sources pointing to dead mirrors
RUN echo "deb http://archive.debian.org/debian-security/ bullseye-security main" > /etc/apt/sources.list.d/bullseye-security.list && \
    echo "deb http://archive.debian.org/debian/ bullseye main" > /etc/apt/sources.list

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-dev ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /app/

RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip install pytube

ENV COOKIES_FILE_PATH="youtube_cookies.txt"

CMD gunicorn app:app & python3 main.py
