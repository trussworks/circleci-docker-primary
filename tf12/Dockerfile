# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install Terraform
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip \
  && [ $(sha256sum terraform_0.12.6_linux_amd64.zip | cut -f1 -d ' ') = 6544eb55b3e916affeea0a46fe785329c36de1ba1bdb51ca5239d3567101876f ] \
  && unzip -d /usr/local/bin -o terraform_0.12.6_linux_amd64.zip \
  && rm -vf terraform_0.12.6_linux_amd64.zip

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
