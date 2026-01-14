#!/bin/bash

set -e

# 安装到用户主目录（机器根目录），不是项目目录
SKILLS_DIR="$HOME/.claude/commands"
REPO_URL="https://github.com/lkyxuan/claude-skills.git"
TMP_DIR="/tmp/claude-skills-$$"

echo "🚀 安装 Claude Commands..."
echo "📁 安装位置: $SKILLS_DIR (机器根目录)"
echo ""

# 创建 commands 目录
mkdir -p "$SKILLS_DIR"

# 克隆仓库
echo "📥 下载 commands..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null

# 复制 commands
echo "📋 安装 commands..."
cp -r "$TMP_DIR/commands/"* "$SKILLS_DIR/"

# 清理
rm -rf "$TMP_DIR"

echo "✅ 安装完成！"
echo "📁 Commands 位置: $SKILLS_DIR"
echo ""
echo "已安装的 commands:"
ls -1 "$SKILLS_DIR" | sed 's/^/  - /'
