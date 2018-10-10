# CircleCI primary docker image to run within
FROM circleci/python:3.6

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

# setup apt
RUN set -ex && cd ~ \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install apt-transport-https lsb-release

# install terraform-docs
RUN set -ex && cd ~ \
  && curl -LO https://github.com/segmentio/terraform-docs/releases/download/v0.4.5/terraform-docs-v0.4.5-linux-amd64 \
  && [ $(sha256sum terraform-docs-v0.4.5-linux-amd64 | cut -f1 -d' ') = e5654c1bcc42f722818d574cd777af5d4adb7533301fb646c0a5cef2001158f3 ] \
  && chmod +x terraform-docs-v0.4.5-linux-amd64 \
  && sudo mv terraform-docs-v0.4.5-linux-amd64 /usr/local/bin/terraform-docs

# install shellcheck
RUN set -ex && cd ~ \
  && curl -LO https://shellcheck.storage.googleapis.com/shellcheck-v0.5.0.linux.x86_64.tar.xz \
  && [ $(sha512sum shellcheck-v0.5.0.linux.x86_64.tar.xz | cut -f1 -d' ') = 475e14bf2705ad4a16d405fa64b94c2eb151a914d5a165ce13e8f9344e6145893f685a650cd32d45a7ab236dedf55f76b31db82e2ef76ad6175a87dd89109790 ] \
  && tar xvfa shellcheck-v0.5.0.linux.x86_64.tar.xz \
  && sudo mv shellcheck-v0.5.0/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v0.5.0 shellcheck-v0.5.0.linux.x86_64.tar.xz

# install Go
RUN set -ex && cd ~ \
  && curl -LO https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz \
  && [ $(sha256sum go1.10.3.linux-amd64.tar.gz | cut -f1 -d' ') = fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035 ] \
  && sudo tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz \
  && sudo ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm go1.10.3.linux-amd64.tar.gz

# install dep
RUN set -ex && cd ~ \
  && curl -LO https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 \
  && [ $(sha256sum dep-linux-amd64 | cut -f1 -d' ') = 287b08291e14f1fae8ba44374b26a2b12eb941af3497ed0ca649253e21ba2f83 ] \
  && chmod 755 dep-linux-amd64 \
  && sudo mv dep-linux-amd64 /usr/local/bin/dep

# install go-bindata
RUN set -ex && cd ~ \
  && curl -LO https://github.com/kevinburke/go-bindata/releases/download/v3.11.0/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = fdebe82be2ea9db495c443d38e986cd438d97ec6719b2f69b35001d546da6e46 ] \
  && chmod 755 go-bindata-linux-amd64 \
  && sudo mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install terraform
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip \
  && [ $(sha256sum terraform_0.11.8_linux_amd64.zip | cut -f1 -d ' ') = 84ccfb8e13b5fce63051294f787885b76a1fedef6bdbecf51c5e586c9e20c9b7 ] \
  && sudo unzip -d /usr/local/bin terraform_0.11.8_linux_amd64.zip \
  && rm -f terraform_0.11.8_linux_amd64.zip

# install Node.js
RUN set -ex && cd ~ \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - \
  && echo "deb https://deb.nodesource.com/node_10.x $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nodesource.list \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install nodejs

# install Yarn
RUN set -ex && cd ~ \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install yarn

# install latest aws cli
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     awscli==1.16.20

# install latest pre-commit
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     pre-commit==1.11.1

CMD ["/bin/sh"]
