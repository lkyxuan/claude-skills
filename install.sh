#!/bin/bash

set -e

SKILLS_DIR="$HOME/.claude/skills"
REPO_URL="https://github.com/lkyxuan/claude-skills.git"
TMP_DIR="/tmp/claude-skills-$$"

echo "🚀 安装 Claude Skills..."

# 创建 skills 目录
mkdir -p "$SKILLS_DIR"

# 克隆仓库
echo "📥 下载 skills..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null

# 复制 skills
echo "📋 安装 skills..."
cp -r "$TMP_DIR/skills/"* "$SKILLS_DIR/"

# 清理
rm -rf "$TMP_DIR"

echo "✅ 安装完成！"
echo "📁 Skills 位置: $SKILLS_DIR"
echo ""
echo "已安装的 skills:"
ls -1 "$SKILLS_DIR" | sed 's/^/  - /'
