# Truss CircleCI Primary Docker Image

[![Build status](https://img.shields.io/circleci/project/github/trussworks/circleci-docker-primary/master.svg)](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master)
[![Version](https://images.microbadger.com/badges/version/trussworks/circleci-docker-primary.svg)](https://microbadger.com/images/trussworks/circleci-docker-primary)

This is [Truss](https://truss.works/)' custom-built docker image for use with CircleCI 2.0 jobs. It includes all the [tools needed to be a primary image](https://circleci.com/docs/2.0/custom-images/#adding-required-and-custom-tools-or-files) as well as additional tools we test and deploy with.

The following languages are installed:

* Python 3.6.x (container base image)
* Go 1.11.x
* Node 10.x

The following tools are installed:

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [go-bindata](https://github.com/kevinburke/go-bindata)
* [dep](https://golang.github.io/dep/)
* [pre-commit](http://pre-commit.com/)
* [ShellCheck](https://www.shellcheck.net/)
* [Terraform](https://www.terraform.io/)
* [terraform-docs](https://github.com/segmentio/terraform-docs)
* [Yarn](https://yarnpkg.com/)

For `packer` tagged images, these additional tools are installed:

* [Ansible](https://pypi.org/project/ansible/)
* [Packer](https://packer.io/)

For more details and exact versions, see [Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/Dockerfile) and [packer/Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/packer/Dockerfile).

For the latest stable images:

* `trussworks/circleci-docker-primary:master`
* `trussworks/circleci-docker-primary:packer`

For static tags, use tags including the git hash. You can find the hashes in this repo, from the [MicroBadger page](https://microbadger.com/images/trussworks/circleci-docker-primary), from the [CircleCI builds page](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master), or from the [Docker Hub tags](https://hub.docker.com/r/trussworks/circleci-docker-primary/tags/) page.
