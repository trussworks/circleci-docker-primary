# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install aws-nuke
ARG ROTATOR_VERSION=0.5.0
ARG ROTATOR_SHA256SUM=38ede362abdf0ef5b997956ccc47975a1366a9e88de641deae17c9475e299483
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/chanzuckerberg/rotator/releases/download/v${ROTATOR_VERSION}/rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz \
  && [ $(sha256sum rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz | cut -f1 -d' ') = ${ROTATOR_SHA256SUM} ] \
  && tar xzf rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz \
  && mv rotator /usr/local/bin \
  && rm -rf rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz

USER circleci
