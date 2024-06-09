# docker pull
# 如果需要特定架构镜像可以手动指定  --platform linux/arm64 , linux/amd64 , linux/arm/v7 等信息
# 查看当前镜像架构信息
# docker image inspect homeassistant/home-assistant:2024.6  | grep Architectur
# "Architecture": "arm64",

#指定 cpu 架构
cat trigger.txt |awk '{print "docker pull --platform linux/arm64 " $1} '
cat trigger.txt |awk '{print "docker pull --platform linux/arm64 " $1} '| sh

# inspect Architectur
cat trigger.txt |awk '{print "docker image inspect  " $1 "| grep Architectur" } '
cat trigger.txt |awk '{print "docker image inspect  " $1 "| grep Architectur" } '| sh

# docker tag
cat trigger.txt | awk '{split($2, arr, ":"); tag=arr[2]; print "docker tag "$1 " " arr[1] ":" tag "-arm64"}'
cat trigger.txt | awk '{split($2, arr, ":"); tag=arr[2]; print "docker tag "$1 " " arr[1] ":" tag "-arm64"}' | sh

# docker push
cat trigger.txt | awk '{split($2, arr, ":"); tag=arr[2]; print "docker push " arr[1] ":" tag "-arm64"}'
cat trigger.txt | awk '{split($2, arr, ":"); tag=arr[2]; print "docker push " arr[1] ":" tag "-arm64"}' | sh