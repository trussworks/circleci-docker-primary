# CircleCI primary docker image to run within
FROM circleci/python:3.8-buster
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# Golang env flags that limit parallel execution
# The golang default is to use the max CPUs or default to 36.
# In CircleCI 2.0 the max CPUs is 2 but golang can't get this from the environment so it defaults to 36
# This can cause build flakiness for larger projects. Setting a value here that can be overridden during execution
# may prevent others from experiencing this same problem.
ENV GOFLAGS=-p=4

# install shellcheck
ARG SHELLCHECK_VERSION=0.7.0
ARG SHELLCHECK_SHA256SUM=39c501aaca6aae3f3c7fc125b3c3af779ddbe4e67e4ebdc44c2ae5cba76c847f
RUN set -ex && cd ~ \
  && curl -sSLO https://shellcheck.storage.googleapis.com/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz \
  && [ $(sha256sum shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz | cut -f1 -d' ') = ${SHELLCHECK_SHA256SUM} ] \
  && tar xvfa shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz \
  && mv shellcheck-v${SHELLCHECK_VERSION}/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v${SHELLCHECK_VERSION} shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz

# install go
ARG GO_VERSION=1.14
ARG GO_SHA256SUM=08df79b46b0adf498ea9f320a0f23d6ec59e9003660b4c9c1ce8e5e2c6f823ca
RUN set -ex && cd ~ \
  && curl -sSLO https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
  && [ $(sha256sum go${GO_VERSION}.linux-amd64.tar.gz | cut -f1 -d' ') = ${GO_SHA256SUM} ] \
  && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go${GO_VERSION}.linux-amd64.tar.gz

# install go-bindata
ARG GO_BINDATA_VERSION=3.11.0
ARG GO_BINDATA_SHA256SUM=fdebe82be2ea9db495c443d38e986cd438d97ec6719b2f69b35001d546da6e46
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v${GO_BINDATA_VERSION}/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = ${GO_BINDATA_SHA256SUM} ] \
  && chmod 755 go-bindata-linux-amd64 \
  && mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install terraform
ARG TERRAFORM_VERSION=0.12.21
ARG TERRAFORM_SHA256SUM=ca0d0796c79d14ee73a3d45649dab5e531f0768ee98da71b31e423e3278e9aa9
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && [ $(sha256sum terraform_${TERRAFORM_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${TERRAFORM_SHA256SUM} ] \
  && unzip -o -d /usr/local/bin -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install terraform-docs
ARG TERRAFORM_DOCS_VERSION=0.8.2
ARG TERRAFORM_DOCS_SHA256SUM=d572e23425dd914e43933761f85dbcde2d7d473d6b960e12b191f3076b36caa0
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/segmentio/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && [ $(sha256sum terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 | cut -f1 -d' ') = ${TERRAFORM_DOCS_SHA256SUM} ] \
  && chmod 755 terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 /usr/local/bin/terraform-docs

# install circleci cli
ARG CIRCLECI_CLI_VERSION=0.1.5879
ARG CIRCLECI_CLI_SHA256SUM=f178ea62c781aec06267017404f87983c87f171fd0e66ef3737916246ae66dd6
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/CircleCI-Public/circleci-cli/releases/download/v${CIRCLECI_CLI_VERSION}/circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz \
  && [ $(sha256sum circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz | cut -f1 -d' ') = ${CIRCLECI_CLI_SHA256SUM} ] \
  && tar xzf circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz \
  && mv circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64/circleci /usr/local/bin \
  && chmod 755 /usr/local/bin/circleci \
  && rm -vrf circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64 circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz

# install hub
ARG HUB_VERSION=2.14.1
ARG HUB_SHA256SUM=734733c9d807715a4ec26ccce0f9987bd19f1c3f84dd35e56451711766930ef0
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz \
  && [ $(sha256sum hub-linux-amd64-${HUB_VERSION}.tgz | cut -f1 -d' ') = ${HUB_SHA256SUM} ] \
  && tar xzf hub-linux-amd64-${HUB_VERSION}.tgz \
  && hub-linux-amd64-${HUB_VERSION}/install \
  && rm -rf hub-linux-amd64-${HUB_VERSION}

# install awscliv2
COPY sigs/awscliv2_pgp.key /tmp/awscliv2_pgp.key
RUN gpg --import /tmp/awscliv2_pgp.key
RUN set -ex && cd ~ \
  && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip \
  && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig" -o awscliv2.sig \
  && gpg --verify awscliv2.sig awscliv2.zip \
  && unzip awscliv2.zip \
  && ./aws/install --update \
  && rm -r awscliv2.zip awscliv2.sig aws

# install pip packages
ARG CACHE_PIP
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex && cd ~ \
  && pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
  && rm -vf /tmp/requirements.txt

# apt-get all the things
# Notes:
# - Add all apt sources first
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Install apt packages \
  && apt-get -qq -y install --no-install-recommends apt-transport-https lsb-release \
  && : Add Node 10.x \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && echo "deb https://deb.nodesource.com/node_10.x $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/nodesource.list \
  && : Add Yarn \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get -qq update \
  && : Install apt packages \
  && apt-get -qq -y install --no-install-recommends nodejs yarn \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

USER circleci
