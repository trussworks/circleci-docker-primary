# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install Terraform
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip \
  && [ $(sha256sum terraform_0.12.3_linux_amd64.zip | cut -f1 -d ' ') = 75e4323b8514074f8c2118ea382fc677c8b1d1730eda323ada222e0fac57f7db ] \
  && unzip -d /usr/local/bin -o terraform_0.12.3_linux_amd64.zip \
  && rm -vf terraform_0.12.3_linux_amd64.zip

# apt-get all the things
ARG CACHE_APT
RUN set -ex && cd ~ \
  && apt-get -qq update \
  && apt-get -y install gawk \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

USER circleci
