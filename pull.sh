#!/bin/bash
# Enable debug mode
set -x

# Pull, tag, and push images for multiple architectures
cat trigger.txt | while read -r line; do
  src_image=$(echo $line | awk '{print $1}')
  dest_image=$(echo $line | awk '{print $2}')

  # Extract the tag from the source image, default to 'latest' if not present
  src_tag=$(echo $src_image | awk -F':' '{print $2}')
  if [ -z "$src_tag" ]; then
    src_tag="latest"
  fi

  echo "Processing image: $src_image with tag: $src_tag"

  # Pull for arm64 architecture
  echo "Pulling $src_image for arm64 architecture..."
  docker pull --platform linux/arm64 $src_image
  if [ $? -ne 0 ]; then
    echo "Failed to pull $src_image for arm64 architecture"
    exit 1
  fi

  # Pull for amd64 architecture
  echo "Pulling $src_image for amd64 architecture..."
  docker pull --platform linux/amd64 $src_image
  if [ $? -ne 0 ]; then
    echo "Failed to pull $src_image for amd64 architecture"
    exit 1
  fi

  # Tag images with architecture-specific tags
  echo "Tagging $src_image as ${dest_image}-arm64..."
  docker tag $src_image $dest_image-arm64
  if [ $? -ne 0 ]; then
    echo "Failed to tag $src_image for arm64 architecture"
    exit 1
  fi

  echo "Tagging $src_image as ${dest_image}-amd64..."
  docker tag $src_image $dest_image-amd64
  if [ $? -ne 0 ]; then
    echo "Failed to tag $src_image for amd64 architecture"
    exit 1
  fi

  # Push images to the registry
  echo "Pushing ${dest_image}-arm64 to the registry..."
  docker push ${dest_image}-arm64
  if [ $? -ne 0 ]; then
    echo "Failed to push ${dest_image}-arm64"
    exit 1
  fi

  echo "Pushing ${dest_image}-amd64 to the registry..."
  docker push ${dest_image}-amd64
  if [ $? -ne 0 ]; then
    echo "Failed to push ${dest_image}-amd64"
    exit 1
  fi

  echo "Successfully processed $src_image with tag: $src_tag"
done
