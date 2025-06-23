#!/usr/bin/env bash

# Exit on any error
set -e 

set -o allexport
source .env
set +o allexport


# Authenticate Docker to ECR
aws ecr get-login-password \
  --region us-east-1 \
  | docker login \
      --username AWS \
      --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

# Build the container image
docker build \
  -f Dockerfile \
  -t ${PROJECT_NAME}-ingest .

# Tag the image for ECR repo
docker tag ${PROJECT_NAME}-ingest:latest \
  ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT_NAME}-ingest:latest

# Push the image to ECR
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT_NAME}-ingest:latest

echo "Image pushed to ECR successfully."
