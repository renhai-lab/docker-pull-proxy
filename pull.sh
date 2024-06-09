#!/bin/bash

# Pull, tag, and push images for multiple architectures
cat trigger.txt | while read -r line; do
  image=$(echo $line | awk '{print $1}')
  tag=$(echo $line | awk '{print $2}')

  # Pull for both arm64 and amd64 architectures
  docker pull --platform linux/arm64 $image
  docker pull --platform linux/amd64 $image

  # Tag images for the registry
  docker tag $image $REGISTRY/$ALIYUN_HUB_NAME/$tag

  # Push images to the registry
  docker push $REGISTRY/$ALIYUN_HUB_NAME/$tag
done

# Create and push a manifest list for multi-architecture support
cat trigger.txt | while read -r line; do
  tag=$(echo $line | awk '{print $2}')

  # Create a manifest list for multi-architecture support
  docker manifest create $REGISTRY/$ALIYUN_HUB_NAME/$tag \
    --amend $REGISTRY/$ALIYUN_HUB_NAME/$tag:arm64 \
    --amend $REGISTRY/$ALIYUN_HUB_NAME/$tag:amd64

  # Push the manifest list
  docker manifest push $REGISTRY/$ALIYUN_HUB_NAME/$tag
done
