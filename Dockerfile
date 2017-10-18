# CircleCI primary docker image to run within
FROM circleci/python:3.6

# install latest aws cli
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check awscli

# install latest ecs-deploy
RUN set -ex && cd ~ \
  && cd ~ \
  && curl -LO https://github.com/silinternational/ecs-deploy/raw/develop/ecs-deploy \
  && chmod +x ecs-deploy \
  && sudo mv ecs-deploy /usr/local/bin

# install latest pre-commit
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check pre-commit

# install latest shellcheck
RUN set -ex && cd ~ \
  && curl -LO https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz \
  && tar xvfa shellcheck-latest.linux.x86_64.tar.xz \
  && sudo mv shellcheck-latest/shellcheck /usr/local/bin \
  && rm -rf shellcheck-latest shellcheck-latest.linux.x86_64.tar.xz

# install terraform
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/terraform/0.10.7/terraform_0.10.7_linux_amd64.zip \
  && sudo unzip -d /usr/local/bin terraform_0.10.7_linux_amd64.zip \
  && rm -f terraform_0.10.7_linux_amd64.zip

CMD ["/bin/sh"]
