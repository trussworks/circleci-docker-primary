# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install Terraform
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip \
  && [ $(sha256sum terraform_0.12.13_linux_amd64.zip | cut -f1 -d ' ') = 63f765a3f83987b67b046a9c31acff1ec9ee618990d0eab4db34eca6c0d861ec ] \
  && unzip -d /usr/local/bin -o terraform_0.12.13_linux_amd64.zip \
  && rm -vf terraform_0.12.13_linux_amd64.zip

# apt-get all the things
ARG CACHE_APT
RUN set -ex && cd ~ \
  && apt-get -qq update \
  && : Install gawk so the terraform-docs pre-commit hack works \
  && apt-get -y --no-install-recommends install gawk \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

USER circleci
