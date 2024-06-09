#!/bin/bash

# Pull, tag, and push images for multiple architectures
cat trigger.txt | while read -r line; do
  image=$(echo $line | awk '{print $1}')
  tag=$(echo $line | awk '{print $2}')

  # Pull for arm64 and amd64 architectures separately
  docker pull --platform linux/arm64 $image
  docker pull --platform linux/amd64 $image

  # Tag images with architecture-specific tags
  docker tag $image:linux/arm64 $REGISTRY/$ALIYUN_HUB_NAME/${tag}-arm64
  docker tag $image:linux/amd64 $REGISTRY/$ALIYUN_HUB_NAME/${tag}-amd64

  # Push images to the registry
  docker push $REGISTRY/$ALIYUN_HUB_NAME/${tag}-arm64
  docker push $REGISTRY/$ALIYUN_HUB_NAME/${tag}-amd64
done
