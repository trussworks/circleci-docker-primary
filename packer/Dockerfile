# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install Packer
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip \
  && [ $(sha256sum packer_1.5.1_linux_amd64.zip | cut -f1 -d ' ') = 3305ede8886bc3fd83ec0640fb87418cc2a702b2cb1567b48c8cb9315e80047d ] \
  && unzip -d /usr/local/bin packer_1.5.1_linux_amd64.zip \
  && rm -vf packer_1.5.1_linux_amd64.zip

# install inspec
RUN set -ex && cd ~ \
  && curl -LO https://packages.chef.io/files/stable/inspec/3.9.3/ubuntu/18.04/inspec_3.9.3-1_amd64.deb \
  && [ $(sha256sum inspec_3.9.3-1_amd64.deb | cut -f1 -d ' ') = 757dd2366a3932adc5fcc9382b30d77de6cc33152585f4c9f94f8918d9d349a7 ] \
  && dpkg -i inspec_3.9.3-1_amd64.deb \
  && rm -vf inspec_3.9.3-1_amd64.deb

# install Python packages
ARG CACHE_PIP_PACKER
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex && cd ~ \
  && pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
  && rm -vf /tmp/requirements.txt

USER circleci
