#!/bin/bash

# Pull, tag, and push images for multiple architectures
cat trigger.txt | while read -r line; do
  image=$(echo $line | awk '{print $1}')
  tag=$(echo $line | awk '{print $2}')

  echo "Processing image: $image with tag: $tag"

  # Pull for arm64 architecture
  echo "Pulling $image for arm64 architecture..."
  docker pull --platform linux/arm64 $image
  if [ $? -ne 0 ]; then
    echo "Failed to pull $image for arm64 architecture"
    exit 1
  fi

  # Pull for amd64 architecture
  echo "Pulling $image for amd64 architecture..."
  docker pull --platform linux/amd64 $image
  if [ $? -ne 0 ]; then
    echo "Failed to pull $image for amd64 architecture"
    exit 1
  fi

  # Tag images with architecture-specific tags
  echo "Tagging $image:linux/arm64 as $REGISTRY/$ALIYUN_HUB_NAME/${tag}-arm64..."
  docker tag $image $REGISTRY/$ALIYUN_HUB_NAME/${tag}-arm64
  if [ $? -ne 0 ]; then
    echo "Failed to tag $image for arm64 architecture"
    exit 1
  fi

  echo "Tagging $image:linux/amd64 as $REGISTRY/$ALIYUN_HUB_NAME/${tag}-amd64..."
  docker tag $image $REGISTRY/$ALIYUN_HUB_NAME/${tag}-amd64
  if [ $? -ne 0 ]; then
    echo "Failed to tag $image for amd64 architecture"
    exit 1
  fi

  # Push images to the registry
  echo "Pushing $REGISTRY/$ALIYUN_HUB_NAME/${tag}-arm64 to the registry..."
  docker push $REGISTRY/$ALIYUN_HUB_NAME/${tag}-arm64
  if [ $? -ne 0 ]; then
    echo "Failed to push $REGISTRY/$ALIYUN_HUB_NAME/${tag}-arm64"
    exit 1
  fi

  echo "Pushing $REGISTRY/$ALIYUN_HUB_NAME/${tag}-amd64 to the registry..."
  docker push $REGISTRY/$ALIYUN_HUB_NAME/${tag}-amd64
  if [ $? -ne 0 ]; then
    echo "Failed to push $REGISTRY/$ALIYUN_HUB_NAME/${tag}-amd64"
    exit 1
  fi

  echo "Successfully processed $image with tag: $tag"
done
