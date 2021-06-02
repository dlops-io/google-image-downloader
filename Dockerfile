# Use the official Debian-hosted Python image
FROM python:3.7-slim-buster

# Prevent apt from showing prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYENV_SHELL=/bin/bash

#RUN sed -i "s#deb http://deb.debian.org/debian buster main#deb http://deb.debian.org/debian buster main contrib non-free#g" /etc/apt/sources.list \
#    && apt-get update \
#    && apt-get install -y --no-install-recommends --no-install-suggests \
#      wget \
#      gcc \
#      g++ \
#      firefox-esr \
#      firefoxdriver && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* && \
#    pip install --no-cache-dir --upgrade pip && \
#    pip install pipenv && \
#    mkdir -p /app
#
###============
### GeckoDriver
###============
#ARG GECKODRIVER_VERSION=latest
#RUN GK_VERSION=$(if [ ${GECKODRIVER_VERSION:-latest} = "latest" ]; then echo "0.26.0"; else echo $GECKODRIVER_VERSION; fi) \
#  && echo "Using GeckoDriver version: "$GK_VERSION \
#  && wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GK_VERSION/geckodriver-v$GK_VERSION-linux64.tar.gz \
#  && rm -rf /opt/geckodriver \
#  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
#  && rm /tmp/geckodriver.tar.gz \
#  && mv /opt/geckodriver /opt/geckodriver-$GK_VERSION \
#  && chmod 755 /opt/geckodriver-$GK_VERSION \
#  && ln -fs /opt/geckodriver-$GK_VERSION /usr/bin/geckodriver

#ARG firefox_ver=80.0.1
#ARG geckodriver_ver=0.27.0
#
#RUN apt-get update \
# && apt-get upgrade -y \
# && apt-get install -y --no-install-recommends --no-install-suggests \
#            ca-certificates \
# && update-ca-certificates \
#    \
# # Install tools for building
# && toolDeps=" \
#        curl bzip2 \
#    " \
# && apt-get install -y --no-install-recommends --no-install-suggests \
#            $toolDeps \
#    \
# # Install dependencies for Firefox
# && apt-get install -y --no-install-recommends --no-install-suggests \
#            `apt-cache depends firefox-esr | awk '/Depends:/{print$2}'` \
#    \
# # Download and install Firefox
# && curl -fL -o /tmp/firefox.tar.bz2 \
#         https://ftp.mozilla.org/pub/firefox/releases/${firefox_ver}/linux-x86_64/en-GB/firefox-${firefox_ver}.tar.bz2 \
# && tar -xjf /tmp/firefox.tar.bz2 -C /tmp/ \
# && mv /tmp/firefox /opt/firefox \
#    \
# # Download and install geckodriver
# && curl -fL -o /tmp/geckodriver.tar.gz \
#         https://github.com/mozilla/geckodriver/releases/download/v${geckodriver_ver}/geckodriver-v${geckodriver_ver}-linux64.tar.gz \
# && tar -xzf /tmp/geckodriver.tar.gz -C /tmp/ \
# && chmod +x /tmp/geckodriver \
# && mv /tmp/geckodriver /usr/bin/ \
#    \
# # Cleanup unnecessary stuff
# && apt-get purge -y --auto-remove \
#                  -o APT::AutoRemove::RecommendsImportant=false \
#            $toolDeps \
# && rm -rf /var/lib/apt/lists/* \
#           /tmp/* \
## && useradd -ms /bin/bash app -d /home/app -G sudo -u 1000 -p "$(openssl passwd -1 passw0rd)" \
# && pip install --no-cache-dir --upgrade pip \
# && pip install pipenv \
# && mkdir -p /app
## && chown app:app /app


RUN apt-get update && apt-get install -y \
    fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libnspr4 libnss3 lsb-release xdg-utils libxss1 libdbus-glib-1-2 \
    curl unzip wget \
    xvfb && \
    GECKODRIVER_VERSION=`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'` && \
    wget https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    tar -zxf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    FIREFOX_SETUP=firefox-setup.tar.bz2 && \
    apt-get purge firefox && \
    wget -O $FIREFOX_SETUP "https://download.mozilla.org/?product=firefox-latest&os=linux64" && \
    tar xjf $FIREFOX_SETUP -C /opt/ && \
    ln -s /opt/firefox/firefox /usr/bin/firefox && \
    rm $FIREFOX_SETUP && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir --upgrade pip && \
    pip install pipenv && \
    mkdir -p /app

# Switch to app user
#USER app
# Work dir
WORKDIR /app

# Install python packages
ADD Pipfile Pipfile.lock /app/
RUN pipenv sync

# Add source code
ADD . /app

# Entry point
ENTRYPOINT ["/bin/bash","./docker-entrypoint.sh"]
