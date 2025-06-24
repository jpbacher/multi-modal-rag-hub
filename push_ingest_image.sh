#!/usr/bin/env bash

# This script builds a Docker image for the ingest service and pushes it to AWS ECR.
# Make sure it is executable: chmod +x push_ingest_image.sh

# Exit on any error
set -e

# Load .env variables
set -o allexport
source .env
set +o allexport

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Single-platform build
docker build \
  -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-ingest:latest .

# Push to ECR
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-ingest:latest


echo "Image pushed to ECR: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-ingest:latest"
