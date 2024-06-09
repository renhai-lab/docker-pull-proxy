#!/bin/bash

# Pull, tag, and push images for multiple architectures
cat trigger.txt | while read -r line; do
  image=$(echo $line | awk '{print $1}')
  tag=$(echo $line | awk '{print $2}')

  # Pull for arm64 and amd64 architectures separately
  docker pull --platform linux/arm64 $image
  docker pull --platform linux/amd64 $image

  # Create a manifest list for multi-architecture support
  docker manifest create $REGISTRY/$tag \
    --amend $image@$(docker image inspect --format='{{index .RepoDigests 0}}' $image --platform linux/arm64) \
    --amend $image@$(docker image inspect --format='{{index .RepoDigests 0}}' $image --platform linux/amd64)

  # Push the manifest list
  docker manifest push $REGISTRY/$tag
done
