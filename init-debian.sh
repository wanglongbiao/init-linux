
#!/bin/bash

# 1、检查并将 /sbin 加入到 $PATH
if [[ ":$PATH:" != *":/sbin:"* ]]; then
    echo "export PATH=\$PATH:/sbin" >> /etc/profile
    source /etc/profile
    echo "已添加 /sbin 到 PATH 环境变量"
else
    echo "/sbin 已在 PATH 环境变量中"
fi

# 2、将当前用户加入到 sudo 用户组
CURRENT_USER=$(whoami)
if ! groups $CURRENT_USER | grep -q '\bsudo\b'; then
    usermod -aG sudo $CURRENT_USER
    echo "已将用户 $CURRENT_USER 添加到 sudo 用户组"
else
    echo "用户 $CURRENT_USER 已在 sudo 用户组中"
fi

# 3、配置 sudo 免密
SUDOERS_FILE="/etc/sudoers.d/nopasswd_$CURRENT_USER"
if [ ! -f "$SUDOERS_FILE" ]; then
    echo "$CURRENT_USER ALL=(ALL) NOPASSWD:ALL" > $SUDOERS_FILE
    chmod 440 $SUDOERS_FILE
    echo "已配置 $CURRENT_USER 用户 sudo 免密"
else
    echo "$CURRENT_USER 用户已配置 sudo 免密"
fi

echo "初始化完成！"