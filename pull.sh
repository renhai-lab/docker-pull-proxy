# Enable debug mode
set -x

# 拉取镜像，指定 CPU 架构
cat trigger.txt | awk '{print "docker pull --platform linux/arm64 " $1}'
cat trigger.txt | awk '{print "docker pull --platform linux/arm64 " $1}' | sh

cat trigger.txt | awk '{print "docker pull --platform linux/amd64 " $1}'
cat trigger.txt | awk '{print "docker pull --platform linux/amd64 " $1}' | sh

# 检查镜像架构信息
cat trigger.txt | awk '{print "docker image inspect " $1 " | grep Architecture" }'
cat trigger.txt | awk '{print "docker image inspect " $1 " | grep Architecture" }' | sh

# 标记镜像
cat trigger.txt | while read -r line; do
  src_image=$(echo $line | awk '{print $1}')
  dest_image=$(echo $line | awk '{print $2}')

  # 为 amd64 架构打标签，保持原始标签
  echo "Tagging $src_image as $dest_image (amd64)..."
  docker tag $src_image $dest_image
  if [ $? -ne 0 ]; then
    echo "Failed to tag $src_image for amd64 architecture"
    exit 1
  fi

  # 为 arm64 架构打标签，加上后缀 -arm64
  arm64_tag="${dest_image}-arm64"
  echo "Tagging $src_image as $arm64_tag (arm64)..."
  docker tag $src_image $arm64_tag
  if [ $? -ne 0 ]; then
    echo "Failed to tag $src_image for arm64 architecture"
    exit 1
  fi
done

# 推送镜像
cat trigger.txt | while read -r line; do
  dest_image=$(echo $line | awk '{print $2}')

  # 推送 amd64 架构的镜像
  echo "Pushing $dest_image (amd64) to the registry..."
  docker push $dest_image
  if [ $? -ne 0 ]; then
    echo "Failed to push $dest_image (amd64)"
    exit 1
  fi

  # 推送 arm64 架构的镜像
  arm64_tag="${dest_image}-arm64"
  e
