---
name: push
description: 一键提交并推送当前分支到远程仓库
---

# Push Skill

## 概述

快速提交并推送代码的 skill。

## 使用场景

- 完成代码修改需要快速提交推送
- 需要保存当前工作进度

## 实现

执行以下步骤：
1. `git add .` - 暂存所有改动
2. `git commit -m "提交信息"` - 提交改动
3. `git push` - 推送到远程

## 示例

```bash
# 提交并推送
git add .
git commit -m "feat: 添加新功能"
git push
```
