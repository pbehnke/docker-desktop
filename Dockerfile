FROM debian:sid-slim

# Metadata
LABEL base.image="docker.mimirdb.info/alpine_oraclejdk8"
LABEL version="0.57"
LABEL software="Vizier-Desktop"
LABEL software.version="0.57"
LABEL description="Vizier, a Multilingual, Multimodal, Provenance-aware, Data-Centric Notebook"
LABEL website="http://vizierdb.info"
LABEL sourcecode="https://github.com/VizierDB"
LABEL documentation="https://github.com/VizierDB/web-api/wiki"
LABEL tags="CSV,Data Cleaning,Databases,Provenance,Workflow,Machine Learning"

# Bring sid up to date
RUN apt-get update -y \
 && apt-get upgrade -y

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1

# Install dependencies
RUN apt-get install -y \
    python2 \
    python-pip \
	openjdk-8-jre-headless \
 && pip2 install \
    setuptools \
    wheel

#install Vizier 
RUN pip install --system vizier-webapi


#download Mimir jars (avoid starting the API by passing a dummy argument -- this can be done more cleanly)
RUN COURSIER_CACHE=/usr/local/mimir/cache /usr/local/mimir/mimir-api --hack-to-exit-the-API; exit 0

#patch for dockerized port & volumes
RUN mv /usr/local/bin/vizier /usr/local/bin/vizier.bak \
 && cat /usr/local/bin/vizier.bak | sed '\
       s/flask run/flask run -h 0.0.0.0/; \
       s:${APP_DATA_DIR}mimir/mimir-api:(cd /data; ${APP_DATA_DIR}mimir/mimir-api):\
       ' > /usr/local/bin/vizier \
 && chmod +x /usr/local/bin/vizier

EXPOSE 5000
EXPOSE 8089

ENV COURSIER_CACHE=/usr/local/mimir/cache

RUN mkdir /data
VOLUME ["/data"]
ENV USER_DATA_DIR=/data/

ENTRYPOINT ["\/usr\/local\/bin\/vizier"]

