# DEPRECATED Truss CircleCI Primary Docker Image

**This repository has been deprecated in favor of [https://github.com/trussworks/docker-circleci](docker-circleci).**

[![Build status](https://img.shields.io/circleci/project/github/trussworks/circleci-docker-primary/master.svg)](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master)

This is [Truss](https://truss.works/)' custom-built docker image for use with CircleCI 2.x jobs. It includes all the [tools needed to be a primary image](https://circleci.com/docs/2.0/custom-images/#adding-required-and-custom-tools-or-files) as well as additional tools we test and deploy with.

The following languages are installed:

- Python 3.8.x (container base image)
- Go 1.14.x
- Node 10.x

The following tools are installed:

- [AWS Command Line Interface](https://aws.amazon.com/cli/)
- [go-bindata](https://github.com/kevinburke/go-bindata)
- [pre-commit](http://pre-commit.com/)
- [ShellCheck](https://www.shellcheck.net/)
- [Terraform](https://www.terraform.io/) 0.12.x (see `tf13` for 0.13.x)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [Yarn](https://yarnpkg.com/)
- [CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/)
- [hub](https://hub.github.com/)
- [goreleaser](https://goreleaser.com/)

For more details and exact versions, see [Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/Dockerfile)

## Tool Specific Images

### tf13

Next major release of Terraform that is currently in beta. This is meant for early testing and will eventually be merged back into the main image. See [tf13/Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/tf13/Dockerfile) for exact versions.

- [Terraform](https://www.terraform.io/) 0.13.x (overwrites Terraform 0.12.x)

### packer

For building AMIs via packer and configuring them with Ansible. See [packer/Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/packer/Dockerfile) for exact versions.

- [Ansible](https://pypi.org/project/ansible/)
- [ansible-lint](https://pypi.org/project/ansible-lint/)
- [Packer](https://packer.io/)

### nuker

For being able to nuke AWS resources in an entire account. See - [nuker/Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/nuker/Dockerfile) for exact versions.

- [AWS-Nuke](https://github.com/rebuy-de/aws-nuke)

### rotator

For rotating AWS Access Keys tied to robot IAM users (e.g., CircleCI) automatically. See [rotator/Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/rotator/Dockerfile) for exact versions.

- [Rotator](https://github.com/chanzuckerberg/rotator)

### ghr

For being able to create a new GitHub release from the command line. See [ghr/Dockerfile](https://github.com/trussworks/circleci-docker-primary/blob/master/ghr/Dockerfile) for exact versions.

- [ghr](https://github.com/tcnksm/ghr)

## Tagging

For the latest stable images:

- `trussworks/circleci-docker-primary:latest`
- `trussworks/circleci-docker-primary:packer`
- `trussworks/circleci-docker-primary:nuker`
- `trussworks/circleci-docker-primary:rotator`
- `trussworks/circleci-docker-primary:tf13`
- `trussworks/circleci-docker-primary:ghr`

For static tags, use tags including the git hash. You can find the hashes in this repo, from the [CircleCI builds page](https://circleci.com/gh/trussworks/circleci-docker-primary/tree/master), or from the [Docker Hub tags](https://hub.docker.com/r/trussworks/circleci-docker-primary/tags/) page.
