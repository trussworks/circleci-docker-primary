# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install terraform
ARG TERRAFORM_VERSION=0.13.6
ARG TERRAFORM_SHA256SUM=55f2db00b05675026be9c898bdd3e8230ff0c5c78dd12d743ca38032092abfc9
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && [ $(sha256sum terraform_${TERRAFORM_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${TERRAFORM_SHA256SUM} ] \
  && unzip -o -d /usr/local/bin terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

USER circleci
