# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install ghr
ARG GHR_VERSION=0.13.0
ARG GHR_SHA256SUM=c428627270ae26e206cb526cb8c7bdfba475dd278f6691ddaf863355adadfa13
RUN set -ex && cd ~ \
    && curl -sSLO https://github.com/tcnksm/ghr/releases/download/v${GHR_VERSION}/ghr_v${GHR_VERSION}_linux_amd64.tar.gz \
    && [ $(sha256sum ghr_v${GHR_VERSION}_linux_amd64.tar.gz | cut -f1 -d' ') = ${GHR_SHA256SUM} ] \
    && tar xzf ghr_v${GHR_VERSION}_linux_amd64.tar.gz \
    && mv ghr_v${GHR_VERSION}_linux_amd64/ghr /usr/local/bin \
    && rm -rf ghr_v${GHR_VERSION}_linux_amd64.tar.gz \
    && rm -rf ghr_v${GHR_VERSION}_linux_amd64

USER circleci
