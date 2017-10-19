# Truss CircleCI Primary Docker Image

[![CircleCI branch](https://img.shields.io/circleci/project/github/trussworks/circleci-docker-primary/master.svg)](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master)

This is [Truss](https://truss.works/)' custom-built docker image for use with CircleCI 2.0 jobs. It includes all the [tools needed to be a primary image](https://circleci.com/docs/2.0/custom-images/#adding-required-and-custom-tools-or-files) as well as the following tools we test and deploy with:

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [ecs-deploy](https://github.com/silinternational/ecs-deploy/)
* [pre-commit](http://pre-commit.com/)
* [ShellCheck](https://www.shellcheck.net/)
* [Terraform](https://www.terraform.io/)

For the latest image use `trussworks/circleci-docker-primary:master`.

For an immutable tag, see the [Docker Hub](https://hub.docker.com/r/trussworks/circleci-docker-primary/tags/) page.
