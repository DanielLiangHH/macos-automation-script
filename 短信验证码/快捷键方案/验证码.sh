#!/bin/bash

# 获取消息数据库路径
db_path="$HOME/Library/Messages/chat.db"
# 定义验证码相关的关键词
KEYWORDS="验证码|校验码|动态码|确认码|security code|verification code"

# 执行SQL查询获取最新消息
latest_message=$(sqlite3 "$db_path" "SELECT text FROM message ORDER BY date DESC LIMIT 1;")

# 检查是否包含关键词
if echo "$latest_message" | grep -qE "$KEYWORDS"; then
    # 提取4到8位的数字（假设验证码是4到8位数字）
    code=$(echo "$latest_message" | grep -oE "[0-9]{4,8}")

    if [ -n "$code" ]; then
        echo "["$(date +"%Y-%m-%d %H:%M:%S")"] 读取验证码: $code"
        # 将验证码复制到剪贴板
        echo "$code" | pbcopy
        # 发送系统通知
        osascript -e "display notification \"验证码已复制到剪贴板: $code\" with title \"验证码通知\""
    else
        osascript -e "display notification \"最新的短信内容提取失败，可能包含验证码，但未找到数字\" with title \"验证码通知\""
    fi
else
    osascript -e "display notification \"最新的短信内容没有验证码\" with title \"验证码通知\""
fi
