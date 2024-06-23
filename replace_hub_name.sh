# 从环境变量中读取 HUB 名称
HUB_NAME="${ALIYUN_HUB_NAME}"

# 替换 trigger.txt 中的 HUB_NAME_PLACEHOLDER
sed -i "s|HUB_NAME_PLACEHOLDER|$HUB_NAME|g" trigger-amd64.txt
sed -i "s|HUB_NAME_PLACEHOLDER|$HUB_NAME|g" trigger-arm64.txt
# 输出替换后的文件内容以供调试
cat trigger.txt
