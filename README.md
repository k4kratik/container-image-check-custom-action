# container-image-check-custom-action

This is a utility which checks whether a given container image is exists or not.

Currently it supports the following registries:

1. Docker Hub
2. AWS ECR

_for ecr, it assumes you have already set up the AWS Creds setup. You can use this official action [(aws-actions/configure-aws-credentials@v4)](https://github.com/aws-actions/configure-aws-credentials) with [aws-actions/amazon-ecr-login](https://github.com/aws-actions/amazon-ecr-login) for the same._

## Usage - Docker Hub

```yaml
- name: Check if the image exists
  uses: k4kratik/container-image-check-custom-action
  with:
    type: dockerhub
    container_repo_name: my-service-name
    image_tag: ${{ github.sha }}
    dockerhub_username: ${{ secrets.DOCKERHUB_USER }}
    dockerhub_token: ${{ secrets.DOCKERHUB_TOKEN }}
```

## Usage - AWS ECR

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: ap-south-1

- name: Login to Amazon ECR
  id: login-ecr
  uses: aws-actions/amazon-ecr-login@v2

- name: Check if the image exists
  uses: k4kratik/container-image-check-custom-action
  with:
    type: dockerhub # or ecr
    container_repo_name: my-service-name
    image_tag: ${{ github.sha }}
```
