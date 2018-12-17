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

# install shellcheck
RUN set -ex && cd ~ \
  && curl -LO https://shellcheck.storage.googleapis.com/shellcheck-v0.6.0.linux.x86_64.tar.xz \
  && [ $(sha256sum shellcheck-v0.6.0.linux.x86_64.tar.xz | cut -f1 -d' ') = 95c7d6e8320d285a9f026b5241f48f1c02d225a1b08908660e8b84e58e9c7dce ] \
  && tar xvfa shellcheck-v0.6.0.linux.x86_64.tar.xz \
  && sudo mv shellcheck-v0.6.0/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v0.6.0 shellcheck-v0.6.0.linux.x86_64.tar.xz

# install Go
RUN set -ex && cd ~ \
  && curl -LO https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz \
  && [ $(sha256sum go1.11.4.linux-amd64.tar.gz | cut -f1 -d' ') = fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b ] \
  && sudo tar -C /usr/local -xzf go1.11.4.linux-amd64.tar.gz \
  && sudo ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm go1.11.4.linux-amd64.tar.gz

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

# install Terraform
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip \
  && [ $(sha256sum terraform_0.11.11_linux_amd64.zip | cut -f1 -d ' ') = 94504f4a67bad612b5c8e3a4b7ce6ca2772b3c1559630dfd71e9c519e3d6149c ] \
  && sudo unzip -d /usr/local/bin terraform_0.11.11_linux_amd64.zip \
  && rm -f terraform_0.11.11_linux_amd64.zip

# install terraform-docs
RUN set -ex && cd ~ \
  && curl -LO https://github.com/segmentio/terraform-docs/releases/download/v0.5.0/terraform-docs-v0.5.0-linux-amd64 \
  && [ $(sha256sum terraform-docs-v0.5.0-linux-amd64 | cut -f1 -d' ') = dbd421c78089fad336afda3d3969abd34e05889bfd24ae91debde16dab5a144a ] \
  && chmod +x terraform-docs-v0.5.0-linux-amd64 \
  && sudo mv terraform-docs-v0.5.0-linux-amd64 /usr/local/bin/terraform-docs

# install awscli
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     awscli==1.16.70

# install pre-commit
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     pre-commit==1.12.0

CMD ["/bin/sh"]
