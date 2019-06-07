# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary:base

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

# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install Packer
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/packer/1.4.1/packer_1.4.1_linux_amd64.zip \
  && [ $(sha256sum packer_1.4.1_linux_amd64.zip | cut -f1 -d ' ') = b713ea79a6fb131e27d65ec3f2227f36932540e71820288c3c5ad770b565ecd7 ] \
  && unzip -d /usr/local/bin packer_1.4.1_linux_amd64.zip \
  && rm -f packer_1.4.1_linux_amd64.zip

# install inspec
RUN set -ex && cd ~ \
  && curl -LO https://packages.chef.io/files/stable/inspec/3.9.3/ubuntu/18.04/inspec_3.9.3-1_amd64.deb \
  && [ $(sha256sum inspec_3.9.3-1_amd64.deb | cut -f1 -d ' ') = 757dd2366a3932adc5fcc9382b30d77de6cc33152585f4c9f94f8918d9d349a7 ] \
  && dpkg -i inspec_3.9.3-1_amd64.deb \
  && rm -f inspec_3.9.3-1_amd64.deb

# install Python packages
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex && cd ~ \
  && pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
  && rm -f /tmp/requirements.txt

USER circleci
CMD ["/bin/sh"]
