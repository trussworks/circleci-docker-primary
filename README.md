# Truss CircleCI Primary Docker Image

[![Build status](https://img.shields.io/circleci/project/github/trussworks/circleci-docker-primary/master.svg)](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master)

This is [Truss](https://truss.works/)' custom-built docker image for use with CircleCI 2.x jobs. It includes all the [tools needed to be a primary image](https://circleci.com/docs/2.0/custom-images/#adding-required-and-custom-tools-or-files) as well as additional tools we test and deploy with.

The following languages are installed:

* Python 3.7.x (container base image)
* Go 1.13.x
* Node 10.x

The following tools are installed:

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [go-bindata](https://github.com/kevinburke/go-bindata)
* [pre-commit](http://pre-commit.com/)
* [ShellCheck](https://www.shellcheck.net/)
* [Terraform](https://www.terraform.io/) 0.12.x (see `tf11` below for 0.11.x)
* [terraform-docs](https://github.com/segmentio/terraform-docs)
* [Yarn](https://yarnpkg.com/)
* [CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/)
* [hub](https://hub.github.com/)

For `tf11` tagged images, these additional tools are installed:

* [Terraform](https://www.terraform.io/) 0.11.x (overwrites Terraform 0.11.x)
* [GNU awk](https://www.gnu.org/software/gawk/) (gawk) – needed so the [terraform-docs pre-commit hook](https://github.com/antonbabenko/pre-commit-terraform/) kludge can work

For `packer` tagged images, these additional tools are installed:

* [Ansible](https://pypi.org/project/ansible/)
* [ansible-lint](https://pypi.org/project/ansible-lint/)
* [Packer](https://packer.io/)

For more details and exact versions, see [Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/Dockerfile) and [packer/Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/packer/Dockerfile).

For the latest stable images:

* `trussworks/circleci-docker-primary:latest`
* `trussworks/circleci-docker-primary:tf11`
* `trussworks/circleci-docker-primary:tf12`
* `trussworks/circleci-docker-primary:packer`

For static tags, use tags including the git hash. You can find the hashes in this repo, from the [CircleCI builds page](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master), or from the [Docker Hub tags](https://hub.docker.com/r/trussworks/circleci-docker-primary/tags/) page.
