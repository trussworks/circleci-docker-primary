# CircleCI primary docker image to run within
FROM circleci/python:3.8-buster
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install shellcheck
RUN set -ex && cd ~ \
  && curl -sSLO https://shellcheck.storage.googleapis.com/shellcheck-v0.7.0.linux.x86_64.tar.xz \
  && [ $(sha512sum shellcheck-v0.7.0.linux.x86_64.tar.xz | cut -f1 -d' ') = 84e06bee3c8b8c25f46906350fb32708f4b661636c04e55bd19cdd1071265112d84906055372149678d37f09a1667019488c62a0561b81fe6a6b45ad4fae4ac0 ] \
  && tar xvfa shellcheck-v0.7.0.linux.x86_64.tar.xz \
  && mv shellcheck-v0.7.0/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v0.7.0 shellcheck-v0.7.0.linux.x86_64.tar.xz

# install Go
RUN set -ex && cd ~ \
  && curl -sSLO https://dl.google.com/go/go1.13.6.linux-amd64.tar.gz \
  && [ $(sha256sum go1.13.6.linux-amd64.tar.gz | cut -f1 -d' ') = a1bc06deb070155c4f67c579f896a45eeda5a8fa54f35ba233304074c4abbbbd ] \
  && tar -C /usr/local -xzf go1.13.6.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go1.13.6.linux-amd64.tar.gz

# install go-bindata
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v3.11.0/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = fdebe82be2ea9db495c443d38e986cd438d97ec6719b2f69b35001d546da6e46 ] \
  && chmod 755 go-bindata-linux-amd64 \
  && mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install Terraform
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.12.19/terraform_0.12.19_linux_amd64.zip \
  && [ $(sha256sum terraform_0.12.19_linux_amd64.zip | cut -f1 -d ' ') = a549486112f5350075fb540cfd873deb970a9baf8a028a86ee7b4472fc91e167 ] \
  && unzip -o -d /usr/local/bin -o terraform_0.12.19_linux_amd64.zip \
  && rm -vf terraform_0.12.19_linux_amd64.zip

# install terraform-docs
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/segmentio/terraform-docs/releases/download/v0.8.0/terraform-docs-v0.8.0-linux-amd64 \
  && [ $(sha256sum terraform-docs-v0.8.0-linux-amd64 | cut -f1 -d' ') = 724aa705f02cb918221af9654a7ef257074aa5d4235c2796453b84fea7958691 ] \
  && chmod 755 terraform-docs-v0.8.0-linux-amd64 \
  && mv terraform-docs-v0.8.0-linux-amd64 /usr/local/bin/terraform-docs

# install CircleCI CLI
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/CircleCI-Public/circleci-cli/releases/download/v0.1.5879/circleci-cli_0.1.5879_linux_amd64.tar.gz \
  && [ $(sha256sum circleci-cli_0.1.5879_linux_amd64.tar.gz | cut -f1 -d' ') = f178ea62c781aec06267017404f87983c87f171fd0e66ef3737916246ae66dd6 ] \
  && tar xzf circleci-cli_0.1.5879_linux_amd64.tar.gz \
  && mv circleci-cli_0.1.5879_linux_amd64/circleci /usr/local/bin \
  && chmod 755 /usr/local/bin/circleci \
  && rm -vrf circleci-cli_0.1.5879_linux_amd64 circleci-cli_0.1.5879_linux_amd64.tar.gz

# install hub
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/github/hub/releases/download/v2.13.0/hub-linux-amd64-2.13.0.tgz \
  && [ $(sha256sum hub-linux-amd64-2.13.0.tgz | cut -f1 -d' ') = e0f117d553f771938ee594ef280e1b2edf3feebab7c7cb55eab0240a76928652 ] \
  && tar xzf hub-linux-amd64-2.13.0.tgz \
  && hub-linux-amd64-2.13.0/install \
  && rm -rf hub-linux-amd64-2.13.0

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
