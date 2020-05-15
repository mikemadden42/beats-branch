FROM debian:buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
        apt-get install --no-install-recommends -y build-essential curl git-core libpcap-dev libsystemd-dev python3 python3-venv vim-nox && \
        apt-get autoclean && \
        rm -rf /var/cache/debconf/* /var/lib/apt/lists/*

RUN curl -Lso - https://dl.google.com/go/go1.13.10.linux-amd64.tar.gz | \
        tar zxf - -C /usr/local

RUN curl -Lso - https://github.com/magefile/mage/releases/download/v1.9.0/mage_1.9.0_Linux-64bit.tar.gz | \
        tar zxf - -C /usr/local/bin

RUN chown root:root /usr/local/bin/mage && \
        chmod 755 /usr/local/bin/mage