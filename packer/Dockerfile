# CircleCI primary docker image to run within
FROM trussworks/circleci-docker-primary

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

# install Packer
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_linux_amd64.zip \
  && [ $(sha256sum packer_1.3.4_linux_amd64.zip | cut -f1 -d ' ') = 73074f4fa07fe15b5d65a694ee7afae2d1a64f0287e6b40897adee77a7afc552 ] \
  && sudo unzip -d /usr/local/bin packer_1.3.4_linux_amd64.zip \
  && rm -f packer_1.3.4_linux_amd64.zip

# install Ansible
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     ansible==2.7.7

# install ansible-lint
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     ansible-lint==4.1.0

CMD ["/bin/sh"]
