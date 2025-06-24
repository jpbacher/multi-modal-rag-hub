#!/usr/bin/env bash

# This script builds a Docker image for the ingest service and pushes it to AWS ECR.
# Make sure it is executable: chmod +x push_ingest_image.sh

# Exit on any error
set -e

# Load .env variables
set -o allexport
source .env
set +o allexport

# Get short Git SHA for tagging
TAG=$(git rev-parse --short HEAD)
export IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-ingest:$TAG

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Disable BuildKit for compatibility with older Docker versions
export DOCKER_BUILDKIT=0  
# Build and push image with unique tag
docker build --no-cache -t $IMAGE_URI .
docker push $IMAGE_URI

echo "Image pushed to ECR: $IMAGE_URI"
