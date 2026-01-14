# Skills 使用说明

本目录包含项目定制的 Claude Code skills，用于自动化文档同步和代码提交流程。

## 📁 文件结构

```
.claude/
├── skills/
│   ├── sync-docs.md          # 文档自动同步 skill
│   ├── push.md                # 增强版提交推送 skill
│   └── README.md              # 本说明文件
├── docs-rules.json       # 文档同步规则配置
└── settings.local.json        # 项目配置
```

## 🚀 快速开始

### 1. 基本工作流

```bash
# 完成代码开发
vim spider/binance/main.py

# 同步文档（自动检测和更新）
/sync-docs

# 提交并推送（自动检测文档需求）
/push
```

### 2. 仅检查文档需求

```bash
# 只看看需要更新哪些文档，不实际更新
/sync-docs --check
```

### 3. 跳过文档检测直接提交

```bash
# 紧急修复，稍后再更新文档
/push --skip-docs
```

## 📚 Skills 详解

### `/sync-docs` - 文档自动同步

**功能**：智能检测代码变更，自动更新 AI-First 文档系统。

**支持的更新类型**：
- ✅ 新增爬虫 → 更新数据资产、采集能力、系统索引
- ✅ 新增消费者 → 更新处理能力、系统索引
- ✅ 新增计算指标 → 更新指标文档、处理能力
- ✅ Kafka Schema 变更 → 更新数据资产
- ✅ API 路由变更 → 更新 API 文档

**使用场景**：

```bash
# 场景 1：新增数据源
你创建了 spider/okx/
↓
/sync-docs
↓
自动更新 4 个文档

# 场景 2：添加新指标
你修改了 polars_engine/calculators/metrics.py
↓
/sync-docs
↓
自动更新计算指标文档

# 场景 3：只检查不更新
/sync-docs --check
↓
显示需要更新的文档列表
```

**详细文档**：查看 `sync-docs.md`

### `/push` - 增强版提交推送

**功能**：智能提交代码，自动检测文档更新需求，规范分支命名和 commit message。

**增强特性**：
- ✅ 推送前自动检测文档更新需求
- ✅ 智能提示：更新/跳过/取消
- ✅ 无缝集成 `/sync-docs`
- ✅ 自动规范分支命名
- ✅ 自动生成 commit message

**使用场景**：

```bash
# 场景 1：标准流程（推荐）
/push
↓
检测到需要更新文档
↓
选择 [1] 先更新文档
↓
自动运行 /sync-docs
↓
一起提交代码和文档

# 场景 2：跳过文档
/push
↓
选择 [2] 跳过文档更新
↓
只提交代码，稍后手动更新文档

# 场景 3：强制跳过检测
/push --skip-docs
↓
完全跳过文档检测
```

**详细文档**：查看 `push.md`

## ⚙️ 配置说明

### 规则配置文件：`docs-rules.json`

定义了代码变更与文档更新的映射规则。

**核心配置**：

```json
{
  "rules": [
    {
      "name": "新增爬虫",
      "pattern": "^spider/([^/]+)/",
      "docs": [
        "ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md",
        "ai-system/L1-capabilities/L1-data-collection-数据采集.md",
        "ai-system/L0-SYSTEM-INDEX-系统索引.md"
      ],
      "action": "add_data_source"
    }
  ]
}
```

**自定义规则**：
1. 编辑 `docs-rules.json`
2. 添加新的规则条目
3. 指定文件匹配模式和需要更新的文档

### 项目配置：`settings.local.json`

控制 skills 的行为。

```json
{
  "push": {
    "auto_check_docs": true,     // 是否自动检测文档更新
    "default_action": "prompt",  // 默认行为：prompt/auto/skip
    "check_sensitive_files": true
  }
}
```

## 📋 最佳实践

### 1. 开发新功能时

```bash
# 1. 完成代码开发
# 2. 立即同步文档
/sync-docs

# 3. 检查更新的文档
git diff ai-system/

# 4. 如果满意，提交推送
/push
```

### 2. 频繁迭代时

```bash
# 使用 --check 避免过度更新
/sync-docs --check

# 只在合适的时候更新文档
/sync-docs
```

### 3. 多人协作时

- ✅ 提交前必须运行 `/sync-docs`
- ✅ 确保文档与代码在同一个 commit
- ✅ PR 前检查文档更新质量

### 4. 紧急修复时

```bash
# 快速修复，跳过文档
/push --skip-docs

# 稍后补充文档
/sync-docs
/push
```

## 🔧 故障排查

### 问题 1：sync-docs 检测不准确

**原因**：规则配置不匹配

**解决**：
1. 检查 `docs-rules.json` 中的 `pattern`
2. 确认文件路径是否符合规则
3. 调整规则或排除模式

### 问题 2：文档更新内容不正确

**原因**：AI 理解代码错误

**解决**：
1. 完善模块的 README.md，提供清晰说明
2. 添加详细的代码注释
3. 手动修正文档内容

### 问题 3：push 没有检测到文档需求

**原因**：
- 规则没有覆盖该文件类型
- 检测被禁用

**解决**：
1. 检查 `settings.local.json` 中 `auto_check_docs` 是否为 true
2. 添加新的规则到 `docs-rules.json`
3. 手动运行 `/sync-docs --check` 验证

### 问题 4：文档格式被破坏

**原因**：Edit 工具定位错误

**解决**：
1. 使用 git 恢复原文档
2. 手动更新文档
3. 报告问题以改进规则

## 🎯 工作流示例

### 完整的功能开发流程

```bash
# 1. 创建新分支（可选，push 会自动处理）
git checkout -b temp-branch

# 2. 开发代码
# 创建 spider/bybit/ 目录
# 编写爬虫代码

# 3. 检查文档需求
/sync-docs --check

# 输出：
# 🔍 检测到需要更新：
#   • L2-DATA-ASSETS-数据资产清单.md
#   • L1-data-collection-数据采集.md
#   • L0-SYSTEM-INDEX-系统索引.md
#   ! spider/bybit/README.md (需要创建)

# 4. 更新文档
/sync-docs

# 5. 检查更新质量
git diff ai-system/
vim ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md

# 6. 如果满意，提交推送
/push

# 7. push 会自动：
#    - 重命名分支为 lkyxuan/feat_bybit-spider
#    - 生成规范的 commit message
#    - 提交代码和文档
#    - 推送到远程

# 8. 创建 PR
# 使用 push 输出的 PR 链接
```

## 📖 相关文档

- [AI-First 文档系统](../../ai-system/L0-SYSTEM-INDEX-系统索引.md)
- [CLAUDE.md 文档更新规则](../../CLAUDE.md#文档更新规则)
- [文档自动进化机制](../../ai-system/L0-SYSTEM-INDEX-系统索引.md#文档维护机制)

## 🤝 贡献

发现问题或有改进建议？

1. 修改规则配置：编辑 `docs-rules.json`
2. 改进 skill 逻辑：编辑 `sync-docs.md` 或 `push.md`
3. 提交反馈：在 PR 或 issue 中说明

---

**维护者**: fewunderstand Team
**最后更新**: 2026-01-13
**版本**: 1.0

🤖 Generated with [Claude Code](https://claude.com/claude-code)
