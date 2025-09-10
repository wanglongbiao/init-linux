#!/bin/bash

# 获取目标用户：优先用传参，否则用环境变量 USER
TARGET_USER=${1:-$USER}

if [ -z "$TARGET_USER" ]; then
    echo "无法确定目标用户，请手动传入：bash init-debian.sh 用户名"
    exit 1
fi

echo "正在为用户 $TARGET_USER 初始化..."

# 1、检查并将 /sbin 加入到 $PATH
if [[ ":$PATH:" != *":/sbin:"* ]]; then
    echo "export PATH=\$PATH:/sbin" >> /etc/profile
    echo "已添加 /sbin 到 PATH 环境变量"
else
    echo "/sbin 已在 PATH 环境变量中"
fi

# 2、将用户加入 sudo 用户组
if ! id -nG "$TARGET_USER" | grep -q '\bsudo\b'; then
    usermod -aG sudo "$TARGET_USER"
    echo "已将用户 $TARGET_USER 添加到 sudo 用户组"
else
    echo "用户 $TARGET_USER 已在 sudo 用户组中"
fi

# 3、配置 sudo 免密
SUDOERS_FILE="/etc/sudoers.d/nopasswd_$TARGET_USER"
if [ ! -f "$SUDOERS_FILE" ]; then
    echo "$TARGET_USER ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
    chmod 440 "$SUDOERS_FILE"
    echo "已配置 $TARGET_USER 用户 sudo 免密"
else
    echo "用户 $TARGET_USER 已配置 sudo 免密"
fi

echo "初始化完成！"
