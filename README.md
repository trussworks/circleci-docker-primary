# Truss CircleCI Primary Docker Image

[![Build status](https://img.shields.io/circleci/project/github/trussworks/circleci-docker-primary/master.svg)](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master)
[![Version](https://images.microbadger.com/badges/version/trussworks/circleci-docker-primary.svg)](https://microbadger.com/images/trussworks/circleci-docker-primary)

This is [Truss](https://truss.works/)' custom-built docker image for use with CircleCI 2.0 jobs. It includes all the [tools needed to be a primary image](https://circleci.com/docs/2.0/custom-images/#adding-required-and-custom-tools-or-files) as well as the following tools we test and deploy with:

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [pre-commit](http://pre-commit.com/)
* [ShellCheck](https://www.shellcheck.net/)
* [Terraform](https://www.terraform.io/)
* [terraform-docs](https://github.com/segmentio/terraform-docs)
* [Yarn](https://yarnpkg.com/)

The following languages are also installed:

* Python 3.6.x (container base image)
* Go 1.10.x
* Node 10.x

For more details and exact versions, see the [Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/Dockerfile).

For the latest stable image use `trussworks/circleci-docker-primary:master`.

For static tags, use the git hash. You can find the hash in this repo, from the [MicroBadger page](https://microbadger.com/images/trussworks/circleci-docker-primary), from the [CircleCI builds page](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master), or from the [Docker Hub tags](https://hub.docker.com/r/trussworks/circleci-docker-primary/tags/) page.
