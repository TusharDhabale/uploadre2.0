FROM python:3.10-slim-bullseye

# Set the working directory first
WORKDIR /app

# Install system dependencies (without the broken apt-get upgrade)
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-dev ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy project files into the working directory
COPY . /app/

# Install python dependencies[cite: 1]
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip install pytube

ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Note: Running two processes with '&' in CMD can sometimes cause container shutdown/signal issues.
CMD gunicorn app:app & python3 main.py
