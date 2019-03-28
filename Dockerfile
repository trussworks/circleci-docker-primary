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

# apt-get all the things
RUN set -ex && cd ~ \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install apt-transport-https lsb-release \
  && : Install Node 10.x \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - \
  && echo "deb https://deb.nodesource.com/node_10.x $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nodesource.list \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install nodejs \
  && : Install Yarn \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install yarn \
  && : Cleanup \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/*

# Update bash
RUN set -ex && cd ~ \
  && curl -sSLO https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz \
  && [ $(sha256sum bash-5.0.tar.gz | cut -f1 -d' ') = b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d ] \
  && tar xfa bash-5.0.tar.gz \
  && cd bash-5.0 \
  && curl -sSLO https://ftp.gnu.org/gnu/bash/bash-5.0-patches/bash50-001 \
  && [ $(sha256sum bash50-001 | cut -f1 -d' ') = f2fe9e1f0faddf14ab9bfa88d450a75e5d028fedafad23b88716bd657c737289 ] \
  && cat bash50-001 | patch -p0  \
  && curl -sSLO https://ftp.gnu.org/gnu/bash/bash-5.0-patches/bash50-002 \
  && [ $(sha256sum bash50-002 | cut -f1 -d' ') = 87e87d3542e598799adb3e7e01c8165bc743e136a400ed0de015845f7ff68707 ] \
  && cat bash50-002 | patch -p0  \
  && CFLAGS="-DSSH_SOURCE_BASHRC" ./configure --prefix=/usr/local \
  && CFLAGS="-DSSH_SOURCE_BASHRC" sudo make install \
  && echo "/usr/local/bin/bash" | sudo tee -a /etc/shells \
  && cd ~ \
  && rm -rf bash-5.0 \
  && ls -alh /usr/local/bin/bash

# install shellcheck
RUN set -ex && cd ~ \
  && curl -sSLO https://shellcheck.storage.googleapis.com/shellcheck-v0.6.0.linux.x86_64.tar.xz \
  && [ $(sha256sum shellcheck-v0.6.0.linux.x86_64.tar.xz | cut -f1 -d' ') = 95c7d6e8320d285a9f026b5241f48f1c02d225a1b08908660e8b84e58e9c7dce ] \
  && tar xvfa shellcheck-v0.6.0.linux.x86_64.tar.xz \
  && sudo mv shellcheck-v0.6.0/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v0.6.0 shellcheck-v0.6.0.linux.x86_64.tar.xz

# install Go
RUN set -ex && cd ~ \
  && curl -sSLO https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz \
  && [ $(sha256sum go1.12.1.linux-amd64.tar.gz | cut -f1 -d' ') = 2a3fdabf665496a0db5f41ec6af7a9b15a49fbe71a85a50ca38b1f13a103aeec ] \
  && sudo tar -C /usr/local -xzf go1.12.1.linux-amd64.tar.gz \
  && sudo ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm go1.12.1.linux-amd64.tar.gz

# install dep
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/golang/dep/releases/download/v0.5.1/dep-linux-amd64 \
  && [ $(sha256sum dep-linux-amd64 | cut -f1 -d' ') = 7479cca72da0596bb3c23094d363ea32b7336daa5473fa785a2099be28ecd0e3 ] \
  && chmod 755 dep-linux-amd64 \
  && sudo mv dep-linux-amd64 /usr/local/bin/dep

# install go-bindata
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v3.11.0/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = fdebe82be2ea9db495c443d38e986cd438d97ec6719b2f69b35001d546da6e46 ] \
  && chmod 755 go-bindata-linux-amd64 \
  && sudo mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install Terraform
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip \
  && [ $(sha256sum terraform_0.11.13_linux_amd64.zip | cut -f1 -d ' ') = 5925cd4d81e7d8f42a0054df2aafd66e2ab7408dbed2bd748f0022cfe592f8d2 ] \
  && sudo unzip -d /usr/local/bin terraform_0.11.13_linux_amd64.zip \
  && rm -f terraform_0.11.13_linux_amd64.zip

# install terraform-docs
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/segmentio/terraform-docs/releases/download/v0.6.0/terraform-docs-v0.6.0-linux-amd64 \
  && [ $(sha256sum terraform-docs-v0.6.0-linux-amd64 | cut -f1 -d' ') = 7863f13b4fa94f7a4cb1eac2751c427c5754ec0da7793f4a34ce5d5d477f7c4f ] \
  && chmod +x terraform-docs-v0.6.0-linux-amd64 \
  && sudo mv terraform-docs-v0.6.0-linux-amd64 /usr/local/bin/terraform-docs

# install pip packages
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex && cd ~ \
      && sudo pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
      && sudo rm -f /tmp/requirements.txt

CMD ["/bin/sh"]
