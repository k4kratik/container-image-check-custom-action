# container-image-check-custom-action

This is a utility which checks whether a given container image is exists or not.

Currently it supports the following registries:

1. Docker Hub
2. AWS ECR

_for ecr, it assumes you have already set up the AWS Creds setup. You can use this official action [(aws-actions/configure-aws-credentials@v4)](https://github.com/aws-actions/configure-aws-credentials) for the same._
