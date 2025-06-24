#!/usr/bin/env bash

# This script builds a Docker image for the ingest service and pushes it to AWS ECR.
# Make sure it is executable: chmod +x push_ingest_image.sh

# Exit on any error
set -e

# Load .env
set -o allexport
source .env
set +o allexport

# Ensure Docker is talking to the right ECR
aws ecr get-login-password \
  --region $AWS_REGION \
| docker login \
    --username AWS \
    --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build & push in one shot (amd64 only, Docker v2 manifest)
docker buildx create --use
docker buildx build \
  --platform linux/amd64 \
  -f Dockerfile \
  -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-ingest:latest \
  --push \
  .

echo "Image pushed to ECR: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME-ingest:latest"
