# CircleCI primary docker image to run within
FROM circleci/python:3.9.0-buster
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# Golang env flags that limit parallel execution
# The golang default is to use the max CPUs or default to 36.
# In CircleCI 2.0 the max CPUs is 2 but golang can't get this from the environment so it defaults to 36
# This can cause build flakiness for larger projects. Setting a value here that can be overridden during execution
# may prevent others from experiencing this same problem.
ENV GOFLAGS=-p=4

# install shellcheck
ARG SHELLCHECK_VERSION=0.7.1
ARG SHELLCHECK_SHA256SUM=64f17152d96d7ec261ad3086ed42d18232fcb65148b44571b564d688269d36c8
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz \
  && [ $(sha256sum shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz | cut -f1 -d' ') = ${SHELLCHECK_SHA256SUM} ] \
  && tar xvfa shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz \
  && mv shellcheck-v${SHELLCHECK_VERSION}/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v${SHELLCHECK_VERSION} shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz

# install go
ARG GO_VERSION=1.15
ARG GO_SHA256SUM=2d75848ac606061efe52a8068d0e647b35ce487a15bb52272c427df485193602
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
ARG TERRAFORM_VERSION=0.14.6
ARG TERRAFORM_SHA256SUM=63a5a45edde435fa3f278c86ce96346ee7f6b204ea949734f26f963b7dbc1074
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && [ $(sha256sum terraform_${TERRAFORM_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${TERRAFORM_SHA256SUM} ] \
  && unzip -o -d /usr/local/bin -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install terraform-docs
ARG TERRAFORM_DOCS_VERSION=0.11.0
ARG TERRAFORM_DOCS_SHA256SUM=8e00ae5b2e3094127d6d52f51527534994e5a4173759bb351d90c91c81823d65
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && [ $(sha256sum terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 | cut -f1 -d' ') = ${TERRAFORM_DOCS_SHA256SUM} ] \
  && chmod 755 terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 /usr/local/bin/terraform-docs

# install tfsec
ARG TFSEC_VERSION=0.38.3
# note: tfsec does not provide the SHASUM with the release, so this is obtained manually.
ARG TFSEC_SHA256SUM=8444cf04c44bc4aa68201e7b5d68a943ba3eff7e8f42fbee9f28961204a7ebd8
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 \
  && [ $(sha256sum tfsec-linux-amd64 | cut -f1 -d' ') = ${TFSEC_SHA256SUM} ] \
  && chmod 755 tfsec-linux-amd64 \
  && mv tfsec-linux-amd64 /usr/local/bin/tfsec

# install circleci cli
ARG CIRCLECI_CLI_VERSION=0.1.6893
ARG CIRCLECI_CLI_SHA256SUM=d4bc8d1a9d7d07862caa5e060cb4accc742205cab651067278e584d1ac727247
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

# install awscliv2, disable default pager (less)
ENV AWS_PAGER=""
ARG AWSCLI_VERSION=2.1.26
COPY sigs/awscliv2_pgp.key /tmp/awscliv2_pgp.key
RUN gpg --import /tmp/awscliv2_pgp.key
RUN set -ex && cd ~ \
  && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o awscliv2.zip \
  && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip.sig" -o awscliv2.sig \
  && gpg --verify awscliv2.sig awscliv2.zip \
  && unzip awscliv2.zip \
  && ./aws/install --update \
  && aws --version \
  && rm -r awscliv2.zip awscliv2.sig aws

#install goreleaser
ARG GORELEASER_VERSION=0.140.0
ARG GORELEASER_SHA256SUM=1aed6f2414483180c52fe4a0a2a8c34da3e0d623eb9a536a5877054e29f69aab
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_Linux_x86_64.tar.gz \
  && [ $(sha256sum goreleaser_Linux_x86_64.tar.gz | cut -f1 -d' ') = ${GORELEASER_SHA256SUM} ] \
  && mkdir -p goreleaser_Linux_x86_64 \
  && tar xf goreleaser_Linux_x86_64.tar.gz -C goreleaser_Linux_x86_64 \
  && mv goreleaser_Linux_x86_64/goreleaser /usr/local/bin \
  && rm -rf goreleaser_Linux_x86_64

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
