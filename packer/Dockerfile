# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install packer
ARG PACKER_VERSION=1.5.1
ARG PACKER_SHA256SUM=3305ede8886bc3fd83ec0640fb87418cc2a702b2cb1567b48c8cb9315e80047d
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
  && [ $(sha256sum packer_${PACKER_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${PACKER_SHA256SUM} ] \
  && unzip -d /usr/local/bin packer_${PACKER_VERSION}_linux_amd64.zip \
  && rm -vf packer_${PACKER_VERSION}_linux_amd64.zip

# install Python packages
ARG CACHE_PIP_PACKER
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex && cd ~ \
  && pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
  && rm -vf /tmp/requirements.txt

USER circleci
