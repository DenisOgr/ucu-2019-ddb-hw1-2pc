FROM python:3.7


COPY . /app/
WORKDIR /app/

# Install required libs
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 htop nano unzip

# Install Supervisor.
RUN \
  apt-get update && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf


# - Check the output of apt-cache policy manually to determine why output is empty [KRNL-5788]
RUN apt-get update | apt-get upgrade -y

#configure application
RUN mkdir -p /var/log/supervisor && \
    mv docker/config/supervisord/* /etc/supervisor/conf.d/

RUN pip install --upgrade pip
#Install python dependencies
RUN pip install -r requirements.txt

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
