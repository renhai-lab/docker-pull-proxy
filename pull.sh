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
cat trigger.txt | awk '{print "docker tag "$1 " " $2}'
cat trigger.txt | awk '{print "docker tag "$1 " " $2}' | sh

# 推送镜像
cat trigger.txt | awk '{print "docker push " $2}'
cat trigger.txt | awk '{print "docker push " $2}' | sh

echo "镜像拉取、标记和推送完成"
