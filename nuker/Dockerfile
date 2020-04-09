# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install aws-nuke
ARG AWSNUKE_VERSION=2.14.0
ARG AWSNUKE_SHA256SUM=c0b72869dc80c1555179603722906f5021f4cb2063e39c85713c37582172a383
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/rebuy-de/aws-nuke/releases/download/v${AWSNUKE_VERSION}/aws-nuke-v${AWSNUKE_VERSION}-linux-amd64.tar.gz \
  && [ $(sha256sum aws-nuke-v${AWSNUKE_VERSION}-linux-amd64.tar.gz | cut -f1 -d' ') = ${AWSNUKE_SHA256SUM} ] \
  && tar xzf aws-nuke-v${AWSNUKE_VERSION}-linux-amd64.tar.gz \
  && mv dist/aws-nuke-v${AWSNUKE_VERSION}-linux-amd64 /usr/local/bin/aws-nuke \
  && rm -rf aws-nuke-v${AWSNUKE_VERSION}-linux-amd64.tar.gz

USER circleci
