# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install Terraform
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip \
  && [ $(sha256sum terraform_0.11.14_linux_amd64.zip | cut -f1 -d ' ') = 9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd ] \
  && unzip -o -d /usr/local/bin terraform_0.11.14_linux_amd64.zip \
  && rm -vf terraform_0.11.14_linux_amd64.zip

USER circleci
