# 我的 Claude Skills

个人 Claude Code skills 集合

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/lkyxuan/claude-skills/main/install.sh | bash
```

或者使用 wget：

```bash
wget -qO- https://raw.githubusercontent.com/lkyxuan/claude-skills/main/install.sh | bash
```

## Skills 列表

- **docs.md** - 文档同步 skill
- **push.md** - 智能提交并推送 skill
- **task.md** - 任务管理 skill

## 添加新 Skill

```bash
cd ~/claude-skills-repo
mkdir skills/新skill名
nano skills/新skill名/SKILL.md
git add .
git commit -m "Add 新skill"
git push
```

## 更新 Skills

重新运行安装命令即可更新到最新版本。
