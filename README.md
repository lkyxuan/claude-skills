# 我的 Claude Commands

个人 Claude Code commands 集合

## 一键安装

**注意**：安装到机器根目录 `~/.claude/commands`，不是项目目录。

```bash
curl -fsSL https://raw.githubusercontent.com/lkyxuan/claude-skills/main/install.sh | bash
```

或者使用 wget：

```bash
wget -qO- https://raw.githubusercontent.com/lkyxuan/claude-skills/main/install.sh | bash
```

## Commands 列表

- **docs.md** - 文档同步 command
- **push.md** - 智能提交并推送 command
- **task.md** - 任务管理 command

## 添加新 Command

```bash
cd ~/claude-skills-repo
mkdir commands/新command名
nano commands/新command名/SKILL.md
git add .
git commit -m "Add 新command"
git push
```

## 更新 Commands

重新运行安装命令即可更新到最新版本。
