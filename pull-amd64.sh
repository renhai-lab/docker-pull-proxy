#指定 cpu 架构
cat trigger.txt |awk '{print "docker pull --platform linux/amd64 " $1} '
cat trigger.txt |awk '{print "docker pull --platform linux/amd64 " $1} '| sh

# inspect Architectur
cat trigger.txt |awk '{print "docker image inspect  " $1 "| grep Architectur" } '
cat trigger.txt |awk '{print "docker image inspect  " $1 "| grep Architectur" } '| sh

# docker tag
cat trigger.txt |awk '{print "docker tag "$1 " " $2} '
cat trigger.txt |awk '{print "docker tag "$1 " " $2} '| sh

# docker push
cat trigger.txt |awk '{print "docker push " $2} '
cat trigger.txt |awk '{print "docker push " $2} '| sh