# CircleCI primary docker image to run within
FROM circleci/python:3.7-stretch

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Truss CircleCI Primary Docker Image" \
      org.label-schema.description="Truss custom-built docker image for CircleCI 2.0 jobs. Includes all tools needed to be a \"primary container\" as well as tools we test and deploy with." \
      org.label-schema.url="https://truss.works/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/trussworks/circleci-docker-primary" \
      org.label-schema.vendor="TrussWorks, Inc." \
      org.label-schema.version=$VCS_REF \
      org.label-schema.schema-version="1.0"

# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# apt-get all the things
RUN set -ex -o pipefail && cd ~ \
  && apt-get -qq update \
  && apt-get -qq -y install --no-install-recommends apt-transport-https lsb-release \
  && : Install Node 10.x \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && echo "deb https://deb.nodesource.com/node_10.x $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get -qq update \
  && apt-get -qq -y install --no-install-recommends nodejs \
  && : Install Yarn \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get -qq update \
  && apt-get -qq -y install --no-install-recommends yarn \
  && : Cleanup \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install shellcheck
RUN set -ex -o pipefail && cd ~ \
  && curl -sSLO https://shellcheck.storage.googleapis.com/shellcheck-v0.6.0.linux.x86_64.tar.xz \
  && [ $(sha256sum shellcheck-v0.6.0.linux.x86_64.tar.xz | cut -f1 -d' ') = 95c7d6e8320d285a9f026b5241f48f1c02d225a1b08908660e8b84e58e9c7dce ] \
  && tar xvfa shellcheck-v0.6.0.linux.x86_64.tar.xz \
  && mv shellcheck-v0.6.0/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v0.6.0 shellcheck-v0.6.0.linux.x86_64.tar.xz

# install Go
RUN set -ex -o pipefail && cd ~ \
  && curl -sSLO https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz \
  && [ $(sha256sum go1.12.5.linux-amd64.tar.gz | cut -f1 -d' ') = aea86e3c73495f205929cfebba0d63f1382c8ac59be081b6351681415f4063cf ] \
  && tar -C /usr/local -xzf go1.12.5.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm go1.12.5.linux-amd64.tar.gz

# install go-bindata
RUN set -ex -o pipefail && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v3.11.0/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = fdebe82be2ea9db495c443d38e986cd438d97ec6719b2f69b35001d546da6e46 ] \
  && chmod 755 go-bindata-linux-amd64 \
  && mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install Terraform
RUN set -ex -o pipefail && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip \
  && [ $(sha256sum terraform_0.11.14_linux_amd64.zip | cut -f1 -d ' ') = 9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd ] \
  && unzip -d /usr/local/bin terraform_0.11.14_linux_amd64.zip \
  && rm -f terraform_0.11.14_linux_amd64.zip

# install terraform-docs
RUN set -ex -o pipefail && cd ~ \
  && curl -sSLO https://github.com/segmentio/terraform-docs/releases/download/v0.6.0/terraform-docs-v0.6.0-linux-amd64 \
  && [ $(sha256sum terraform-docs-v0.6.0-linux-amd64 | cut -f1 -d' ') = 7863f13b4fa94f7a4cb1eac2751c427c5754ec0da7793f4a34ce5d5d477f7c4f ] \
  && chmod 755 terraform-docs-v0.6.0-linux-amd64 \
  && mv terraform-docs-v0.6.0-linux-amd64 /usr/local/bin/terraform-docs

# install pip packages
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex -o pipefail && cd ~ \
  && pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
  && rm -f /tmp/requirements.txt

# install CircleCI CLI
RUN set -ex -o pipefail && cd ~ \
  && curl -sSLO https://github.com/CircleCI-Public/circleci-cli/releases/download/v0.1.5607/circleci-cli_0.1.5607_linux_amd64.tar.gz \
  && [ $(sha256sum circleci-cli_0.1.5607_linux_amd64.tar.gz | cut -f1 -d' ') = 125e711d4e834254fca04a381530ce2f2d7e337e4f4710cd8a4a3283c19a7b9b ] \
  && tar xzf circleci-cli_0.1.5607_linux_amd64.tar.gz \
  && mv circleci-cli_0.1.5607_linux_amd64/circleci /usr/local/bin \
  && chmod 755 /usr/local/bin/circleci \
  && rm -rf circleci-cli_0.1.5607_linux_amd64 circleci-cli_0.1.5607_linux_amd64.tar.gz

USER circleci
CMD ["/bin/sh"]
