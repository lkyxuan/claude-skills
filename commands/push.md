# /push - 智能提交并推送

快速提交当前所有更改并推送到远程分支，自动处理分支命名和 commit message。

## 推荐工作流

```bash
# 1. 开发代码
vim spider/binance/main.py

# 2. 同步文档（包括 ai-system 和模块 README）
/docs

# 3. 提交推送
/push
```

## 使用方式
```
/push [commit message]
/push              # 自动生成 branch 名称和 commit message
/push fix: xxx     # 使用指定的 commit message
```

## 执行流程

### 1. 检查状态
```bash
git status
git diff --stat
git diff  # 查看详细变更
```

**重要**：在后续步骤中，必须先读取 git diff 的完整内容，用于：
- 判断分支名称是否具体（步骤 3）
- 生成准确的 commit message（步骤 4）

### 2. 🚨 文档同步检测（强制）

**工作流**：必须先 `/docs`，再 `/push`

**检测**：检查代码变更是否需要更新文档（规则见 `.claude/docs-rules.json`）

**结果**：
- ✅ 文档已同步 → 继续提交
- ❌ 检测到需要同步 → **阻止提交**，提示先运行 `/docs`

**注意**：文档包括 ai-system 文档 + 模块 README

### 3. 生成分支名（强制）

**根据 GitHub workflow 规则生成分支名**（`.github/workflows/auto-pr.yml`）

**格式**：`<username>/<type>_<description>` 或 `<type>_<description>`

**支持的类型**（会触发自动 PR）：
- `feature` - 新功能 → PR 到 `dev`
- `bugfix` - Bug 修复 → PR 到 `dev`
- `hotfix` - 生产环境紧急修复 → PR 到 `main`
- `chore` - 日常维护 → PR 到 `dev`
- `refactor` - 代码重构 → PR 到 `dev`
- `test` - 测试相关 → PR 到 `dev`
- `docs` - 文档相关 → PR 到 `dev`

**生成流程**：
1. 分析 `git diff`：改了什么？目的是什么？
2. 判断类型：新功能/修复/文档/重构...
3. 生成描述：2-4 个单词，体现业务含义
4. 生成分支名：`lkyxuan/<type>_<description>`
5. 重命名：`git branch -m <new-name>`

**示例**：
- 简化配置 → `lkyxuan/docs_simplify-config`
- 新增爬虫 → `lkyxuan/feature_add-binance-spider`
- 修复连接 → `lkyxuan/bugfix_kafka-connection`
- 紧急修复 → `lkyxuan/hotfix_critical-security-fix`

**注意**：分支名必须匹配 workflow 规则才能触发自动 PR

### 4. 生成 Commit Message

基于 `git diff` 自动生成 Conventional Commits 格式：

```
<type>: <description>

[optional body]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**类型**：feat/fix/docs/refactor/test/chore/ci/perf/style

### 5. 提交和推送

```bash
git add -A
git commit -m "<message>"
git push origin <branch>  # 新分支加 -u
```

## 安全检查

- ⚠️ 敏感文件检测：`.env`, `*.key`, `*credentials*`
- ❌ 禁止 `--force`
- ❌ 禁止直接推送到 `main`/`master`

## 示例

### 标准工作流

```bash
# 1. 开发代码
vim spider/binance/main.py

# 2. 同步文档
/docs
# → 创建 spider/binance/README.md
# → 更新 ai-system 文档

# 3. 提交推送
/push
# → 检查文档：✓ 已同步
# → 生成分支名：lkyxuan/feature_add-binance-spider（匹配 workflow 规则）
# → 重命名分支
# → 生成 commit: feat: add binance spider
# → 推送成功
# → 自动触发 PR 到 dev 分支
```

### 忘记同步文档

```bash
/push
# → ❌ 检测到需要同步文档
# → 阻止提交，提示："请先运行 /docs"
```

## 最佳实践

1. **遵循标准工作流**：开发 → `/docs` → `/push`
2. **文档优先**：代码和文档一起提交，保持同步
3. **及时提交**：完成功能后立即提交，不要积累太多变更
4. **使用正确的分支类型**：
   - 新功能 → `feature`
   - Bug 修复 → `bugfix`
   - 紧急修复（生产环境）→ `hotfix`
   - 文档 → `docs`
   - 重构 → `refactor`
5. **分支名触发自动 PR**：符合 workflow 规则的分支会自动创建 PR

## 与 /docs 的关系

- **`/docs`**：负责所有文档同步（ai-system + 模块 README）
- **`/push`**：负责提交推送，会检测文档是否已同步
- **配置文件**：`.claude/docs-rules.json`（详见 `/docs` skill）

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
