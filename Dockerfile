# CircleCI primary docker image to run within
FROM circleci/python:3.7-stretch
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
  && curl -sSLO https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz \
  && [ $(sha256sum go1.13.1.linux-amd64.tar.gz | cut -f1 -d' ') = 94f874037b82ea5353f4061e543681a0e79657f787437974214629af8407d124 ] \
  && tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go1.13.1.linux-amd64.tar.gz

# install go-bindata
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v3.11.0/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = fdebe82be2ea9db495c443d38e986cd438d97ec6719b2f69b35001d546da6e46 ] \
  && chmod 755 go-bindata-linux-amd64 \
  && mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install Terraform
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip \
  && [ $(sha256sum terraform_0.11.14_linux_amd64.zip | cut -f1 -d ' ') = 9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd ] \
  && unzip -d /usr/local/bin terraform_0.11.14_linux_amd64.zip \
  && rm -vf terraform_0.11.14_linux_amd64.zip

# install terraform-docs
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/segmentio/terraform-docs/releases/download/v0.6.0/terraform-docs-v0.6.0-linux-amd64 \
  && [ $(sha256sum terraform-docs-v0.6.0-linux-amd64 | cut -f1 -d' ') = 7863f13b4fa94f7a4cb1eac2751c427c5754ec0da7793f4a34ce5d5d477f7c4f ] \
  && chmod 755 terraform-docs-v0.6.0-linux-amd64 \
  && mv terraform-docs-v0.6.0-linux-amd64 /usr/local/bin/terraform-docs

# install CircleCI CLI
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/CircleCI-Public/circleci-cli/releases/download/v0.1.5879/circleci-cli_0.1.5879_linux_amd64.tar.gz \
  && [ $(sha256sum circleci-cli_0.1.5879_linux_amd64.tar.gz | cut -f1 -d' ') = f178ea62c781aec06267017404f87983c87f171fd0e66ef3737916246ae66dd6 ] \
  && tar xzf circleci-cli_0.1.5879_linux_amd64.tar.gz \
  && mv circleci-cli_0.1.5879_linux_amd64/circleci /usr/local/bin \
  && chmod 755 /usr/local/bin/circleci \
  && rm -vrf circleci-cli_0.1.5879_linux_amd64 circleci-cli_0.1.5879_linux_amd64.tar.gz

# install pip packages
ARG CACHE_PIP
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex && cd ~ \
  && pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
  && rm -vf /tmp/requirements.txt

# apt-get all the things
ARG CACHE_APT
RUN set -ex && cd ~ \
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
  && rm -vrf /var/lib/apt/lists/*

USER circleci
