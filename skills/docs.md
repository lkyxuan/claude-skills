# /docs - 智能文档同步

自动检测代码变更，智能更新 AI-First 文档系统。

## 使用方式

```bash
/docs              # 检测并更新文档
/docs --check      # 仅检查，不更新
/docs --auto       # 自动更新，不询问
```

## 核心功能

### 1. 检测变更

检测 `git diff` 中的代码变更，判断需要更新的文档。

**执行步骤**：
```bash
# 1. 获取 git 变更
git diff --cached --name-status  # 已暂存的文件
git diff --name-status           # 未暂存的文件

# 2. 分析变更类型
- 新增文件: A
- 修改文件: M
- 删除文件: D
- 重命名: R
```

### 2. 检测规则引擎

根据文件路径匹配规则，判断需要更新的文档。

#### 规则映射表

| 变更文件路径 | 需要更新的文档 | 更新内容 |
|-------------|---------------|---------|
| `spider/<source>/**` | • `ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md`<br>• `ai-system/L1-capabilities/L1-data-collection-数据采集.md`<br>• `ai-system/L0-SYSTEM-INDEX-系统索引.md`<br>• `spider/<source>/README.md` | • 添加数据源描述<br>• 更新采集能力列表<br>• 更新系统核心能力表格<br>• 创建/更新模块文档 |
| `consumer/<module>/**` | • `ai-system/L1-capabilities/L1-data-processing-数据处理.md`<br>• `ai-system/L0-SYSTEM-INDEX-系统索引.md`<br>• `consumer/<module>/README.md` | • 添加处理能力描述<br>• 更新系统核心能力表格<br>• 创建/更新模块文档 |
| `consumer/polars_engine/calculators/**` | • `ai-system/L2-assets/L2-computed-indicators-计算指标.md`<br>• `ai-system/L1-capabilities/L1-data-processing-数据处理.md` | • 添加新计算指标<br>• 更新计算能力说明 |
| `kafka/**` | • `docs/infrastructure/kafka/README.md` | • 更新 Kafka 配置文档 |
| `kafka/topics/**`<br>`**/topic_schema/**` | • `ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md` | • 更新 Kafka Topic Schema |
| `api/routes/**` | • `api/README.md`<br>• `ai-system/L0-SYSTEM-INDEX-系统索引.md` | • 更新 API 文档<br>• 更新 API 访问能力 |
| `dashboard/**` | • `dashboard/README.md` | • 更新 Dashboard 文档 |
| `infrastructure/**` | • `docs/infrastructure/README.md` | • 更新基础设施文档 |
| **🆕 文档双向同步** | | |
| `spider/<source>/README.md` | • `ai-system/L2-assets/`<br>• `ai-system/L1-capabilities/`<br>• `ai-system/L0-SYSTEM-INDEX` | • 模块文档修改后同步到 ai-system |
| `consumer/<module>/README.md` | • `ai-system/L1-capabilities/`<br>• `ai-system/L0-SYSTEM-INDEX` | • 模块文档修改后同步到 ai-system |
| `ai-system/L2-assets/**` | • `ai-system/L1-capabilities/`<br>• `ai-system/L0-SYSTEM-INDEX`<br>• 相关模块 README | • L2 资产文档修改后同步到相关文档 |
| `ai-system/L1-capabilities/**` | • `ai-system/L0-SYSTEM-INDEX`<br>• `ai-system/L2-assets/`<br>• 相关模块 README | • L1 能力文档修改后同步到索引和资产 |
| `ai-system/L0-SYSTEM-INDEX` | • `ai-system/L1-capabilities/`<br>• `ai-system/L2-assets/`<br>• `ai-system/L3-scenarios/`<br>• `ai-system/L4-extensions/` | • L0 索引修改后检查各层文档一致性 |
| `docs/infrastructure/**`<br>`docs/monitoring/**` | • `ai-system/L0-SYSTEM-INDEX`<br>• `ai-system/L1-capabilities/` | • 技术文档修改后更新相关能力描述 |

### 3. 智能更新逻辑

#### 新增爬虫 (spider/<source>/)

**检测条件**：
- 新增或修改 `spider/<source>/` 目录下的文件
- 排除 `__pycache__`, `*.pyc`, `.env` 等文件

**自动执行**：

1. **读取爬虫信息**
   ```python
   # 优先读取 spider/<source>/README.md
   # 如果不存在，读取 spider/<source>/__init__.py 或主文件
   # 提取：数据源名称、描述、采集频率、数据类型
   ```

2. **更新 L2-DATA-ASSETS-数据资产清单.md**
   ```markdown
   ## 可用数据源

   | 数据源 | 描述 | 更新频率 | 数据格式 | Kafka Topic | 文档 |
   |-------|------|---------|---------|-------------|------|
   | <source> | <描述> | <频率> | <格式> | <topic> | [详情](../spider/<source>/README.md) |
   ```

3. **更新 L1-data-collection-数据采集.md**
   - 在 "## 数据采集能力" 下添加新的小节
   - 包含：数据源说明、采集方式、配置示例

4. **更新 L0-SYSTEM-INDEX-系统索引.md**
   ```markdown
   | 📊 数据采集 | <source> <描述> | <API> | [详情](L1-capabilities/L1-data-collection-数据采集.md#<source>) |
   ```

5. **创建/更新 spider/<source>/README.md**
   - 如果不存在，根据代码生成标准模板
   - 包含：功能说明、配置项、使用示例、数据 Schema

#### 新增消费者 (consumer/<module>/)

**检测条件**：
- 新增或修改 `consumer/<module>/` 目录下的文件

**自动执行**：

1. **读取消费者信息**
   - 从 `consumer/<module>/README.md` 或代码中提取
   - 提取：模块名称、功能描述、输入输出、处理逻辑

2. **更新 L1-data-processing-数据处理.md**
   - 添加处理能力说明

3. **更新 L0-SYSTEM-INDEX-系统索引.md**
   - 在系统核心能力表格中添加

4. **创建/更新 consumer/<module>/README.md**
   - 标准模板：功能、配置、使用示例

#### 新增计算指标 (polars_engine/calculators/)

**检测条件**：
- 修改 `consumer/polars_engine/calculators/` 下的文件
- 检测新增的计算函数

**自动执行**：

1. **解析计算逻辑**
   - 读取 Hamilton DAG 函数定义
   - 提取：指标名称、计算公式、输入输出

2. **更新 L2-computed-indicators-计算指标.md**
   ```markdown
   ### <指标名称>

   **描述**: <说明>

   **计算公式**:
   \`\`\`
   <公式>
   \`\`\`

   **输入数据**:
   - <字段1>
   - <字段2>

   **输出字段**: <字段名>

   **更新频率**: <频率>
   ```

3. **更新 L1-data-processing-数据处理.md**
   - 在计算能力章节更新

#### 修改 Kafka Topic Schema

**检测条件**：
- 修改包含 "topic", "schema", "kafka" 关键词的文件
- 修改 `kafka/` 目录下的配置文件

**自动执行**：

1. **提取 Schema 变更**
   - 解析新的字段定义
   - 对比旧 Schema

2. **更新 L2-DATA-ASSETS-数据资产清单.md**
   - 更新相应 Topic 的 Schema 定义

3. **检查影响范围**
   - 提示可能受影响的 consumer
   - 建议检查相关处理逻辑

#### 🆕 文档双向同步

**核心理念**：文档也是代码资产，需要保持一致性。

##### 场景 1：模块 README 修改 → ai-system

**检测条件**：
- 修改 `spider/<source>/README.md`
- 修改 `consumer/<module>/README.md`

**自动执行**：

1. **读取模块 README 的关键信息**
   - 数据源名称、描述
   - 更新频率、数据格式
   - 功能说明

2. **同步到 ai-system**
   - 更新 `L2-DATA-ASSETS-数据资产清单.md` 中的描述
   - 更新 `L1-capabilities` 中的能力说明
   - 更新 `L0-SYSTEM-INDEX` 中的表格

3. **保持描述一致**
   - 如果 README 改了更新频率，ai-system 也要改
   - 如果 README 改了功能描述，ai-system 也要同步

**示例**：
```bash
# 修改了 spider/binance/README.md
# 把更新频率从 "3分钟" 改为 "5分钟"

/docs

# 自动更新：
# ✓ L2-DATA-ASSETS-数据资产清单.md：Binance 频率 → 5分钟
# ✓ L1-data-collection-数据采集.md：描述同步
# ✓ L0-SYSTEM-INDEX：表格更新
```

##### 场景 2：L2-资产文档修改 → 相关文档

**检测条件**：
- 修改 `ai-system/L2-assets/` 下的任何文档

**自动执行**：

1. **检查影响范围**
   - 哪些 L1 能力文档引用了这个资产？
   - 哪些模块 README 需要同步？
   - L0 索引中的表格是否需要更新？

2. **同步修改**
   - 更新相关的能力描述
   - 检查模块 README 是否有冲突
   - 更新系统索引

**示例**：
```bash
# 修改了 L2-DATA-ASSETS-数据资产清单.md
# 添加了新的字段说明

/docs

# 自动检查：
# ✓ 检查 L1-data-collection 是否需要更新
# ✓ 检查 spider/binance/README.md 是否需要同步
# ✓ 更新 L0-SYSTEM-INDEX 的引用
```

##### 场景 3：L1-能力文档修改 → 索引和资产

**检测条件**：
- 修改 `ai-system/L1-capabilities/` 下的文档

**自动执行**：

1. **向上同步到 L0**
   - 更新系统索引中的能力表格
   - 更新能力图谱

2. **向下检查 L2**
   - 能力描述变化是否影响资产说明？
   - 是否需要更新数据资产文档？

3. **横向检查模块**
   - 相关的模块 README 是否需要同步？

**示例**：
```bash
# 修改了 L1-data-collection-数据采集.md
# 更新了 Binance 的采集能力描述

/docs

# 自动执行：
# ✓ 更新 L0-SYSTEM-INDEX：能力表格
# ✓ 检查 L2-DATA-ASSETS：Binance 描述
# ✓ 检查 spider/binance/README.md
```

##### 场景 4：L0-系统索引修改 → 各层文档

**检测条件**：
- 修改 `ai-system/L0-SYSTEM-INDEX-系统索引.md`

**自动执行**：

1. **检查各层一致性**
   - L1 能力图谱是否与索引一致？
   - L2 资产清单是否与索引表格一致？
   - L3/L4 的链接是否正确？

2. **提示不一致**
   - 发现描述冲突
   - 建议修正方向

**示例**：
```bash
# 修改了 L0-SYSTEM-INDEX
# 在能力表格中改了某个描述

/docs

# 自动检查：
# ⚠️ L1-CAPABILITIES 中的描述与 L0 不一致
# ⚠️ 建议同步：...
```

##### 场景 5：技术文档修改 → ai-system

**检测条件**：
- 修改 `docs/infrastructure/` 等技术文档

**自动执行**：

1. **检查是否影响能力描述**
   - Kafka 配置改了 → L1-data-storage 要更新吗？
   - 监控方案改了 → L1-automation 要更新吗？

2. **同步关键信息**
   - 技术栈版本号
   - 配置参数
   - 架构图

**示例**：
```bash
# 修改了 docs/infrastructure/kafka/README.md
# 升级了 Kafka 版本

/docs

# 自动检查：
# ✓ L0-SYSTEM-INDEX：技术栈表格更新
# ✓ L1-data-storage：Kafka 能力描述检查
```

### 4. 执行模式

#### 检查模式 (--check)

```bash
/docs --check
```

**输出示例**：
```
🔍 检测到以下代码变更需要更新文档：

📁 spider/binance/
   需要更新：
   ✓ ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md
   ✓ ai-system/L1-capabilities/L1-data-collection-数据采集.md
   ✓ ai-system/L0-SYSTEM-INDEX-系统索引.md
   ! spider/binance/README.md (不存在，需要创建)

📁 consumer/polars_engine/calculators/
   需要更新：
   ✓ ai-system/L2-assets/L2-computed-indicators-计算指标.md
   ✓ ai-system/L1-capabilities/L1-data-processing-数据处理.md

运行 /docs 开始更新文档
```

#### 交互模式 (默认)

```bash
/docs
```

**流程**：
1. 检测变更，显示需要更新的文档列表
2. 询问确认："是否继续更新？[Y/n]"
3. 逐个更新文档
4. 显示更新摘要
5. 提示用户检查并提交

#### 自动模式 (--auto)

```bash
/docs --auto
```

**流程**：
1. 检测变更
2. 自动更新所有文档
3. 显示更新摘要
4. 不询问确认

### 5. 更新摘要

更新完成后，显示详细摘要：

```
✅ 文档同步完成！

📝 更新的文档：
  ✓ ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md
    • 添加 Binance 数据源

  ✓ ai-system/L1-capabilities/L1-data-collection-数据采集.md
    • 添加 Binance 采集能力说明

  ✓ ai-system/L0-SYSTEM-INDEX-系统索引.md
    • 系统核心能力表格新增 Binance

📄 创建的文档：
  + spider/binance/README.md

💡 建议：
  • 检查更新的文档内容是否准确
  • 运行 /push 提交变更
```

## 与 /push 集成

当运行 `/push` 时，自动执行检测逻辑：

```bash
/push

# 内部流程：
1. 检查 git status
2. 运行 sync-docs --check（静默）
3. 如果需要更新文档：

   显示提示：
   ┌─────────────────────────────────────┐
   │ 🔍 检测到需要更新以下文档：        │
   │                                     │
   │ • L2-DATA-ASSETS-数据资产清单.md   │
   │ • L1-data-collection-数据采集.md    │
   │                                     │
   │ 是否先更新文档？                    │
   │ [1] 是，先运行 /docs（推荐）  │
   │ [2] 否，跳过文档更新                │
   │ [3] 取消本次提交                    │
   └─────────────────────────────────────┘

   用户选择 [1]：
   → 运行 /docs
   → 更新完成后继续 /push 流程

   用户选择 [2]：
   → 继续提交代码，文档稍后手动更新

   用户选择 [3]：
   → 取消提交

4. 如果不需要更新：
   → 直接继续 /push 流程
```

## 安全检查

### 防止过度更新
- 只更新明确需要的文档
- 不修改不相关的章节
- 保留用户手动编写的内容

### 备份机制
- 更新前自动创建 git stash（可选）
- 支持 undo 操作

### 验证机制
- 更新后检查文档格式
- 验证 Markdown 链接完整性
- 检测是否破坏现有结构

## 配置文件（可选）

可以在 `.claude/docs-rules.json` 中自定义规则：

```json
{
  "rules": [
    {
      "pattern": "spider/*/",
      "docs": [
        "ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md",
        "ai-system/L1-capabilities/L1-data-collection-数据采集.md",
        "ai-system/L0-SYSTEM-INDEX-系统索引.md"
      ],
      "action": "add_data_source"
    },
    {
      "pattern": "consumer/*/",
      "docs": [
        "ai-system/L1-capabilities/L1-data-processing-数据处理.md",
        "ai-system/L0-SYSTEM-INDEX-系统索引.md"
      ],
      "action": "add_consumer"
    }
  ],
  "ignore": [
    "**/__pycache__/**",
    "**/*.pyc",
    "**/.env*",
    "**/node_modules/**"
  ]
}
```

## 实现说明

AI 执行此 skill 时：

1. **使用 Bash 工具获取 git diff**
2. **使用 Grep/Read 工具分析代码**
3. **使用 Read 工具读取现有文档**
4. **使用 Edit 工具更新文档**（精确定位，不破坏其他内容）
5. **使用 Write 工具创建新文档**（如果需要）
6. **生成详细的更新报告**

## 最佳实践

1. **频繁使用**：每次完成功能开发后立即运行
2. **先检查后更新**：使用 `--check` 先看看需要更新什么
3. **集成到工作流**：配合 `/push` 使用，确保文档始终同步
4. **定期审查**：虽然是自动更新，但定期检查文档质量
5. **手动完善**：自动更新是基础，重要文档需要手动补充细节

## 示例场景

### 场景 1：新增 Binance 爬虫

```bash
# 1. 完成代码
你创建了 spider/binance/ 目录和相关代码

# 2. 同步文档
/docs

# 输出：
🔍 检测到新增数据源：Binance
📝 正在更新文档...
  ✓ 更新 L2-DATA-ASSETS-数据资产清单.md
  ✓ 更新 L1-data-collection-数据采集.md
  ✓ 更新 L0-SYSTEM-INDEX-系统索引.md
  + 创建 spider/binance/README.md

✅ 文档同步完成！

# 3. 提交代码和文档
/push
```

### 场景 2：添加新计算指标

```bash
# 1. 修改 polars_engine/calculators/price_metrics.py
# 添加了 calculate_rsi() 函数

# 2. 同步文档
/docs

# 输出：
🔍 检测到新增计算指标：RSI (相对强弱指标)
📝 正在更新文档...
  ✓ 更新 L2-computed-indicators-计算指标.md
  ✓ 更新 L1-data-processing-数据处理.md

✅ 文档同步完成！
```

### 场景 3：配合 /push 使用

```bash
# 直接运行 /push
/push

# 输出：
🔍 检测到需要更新以下文档：
  • L2-DATA-ASSETS-数据资产清单.md
  • L1-data-collection-数据采集.md

是否先更新文档？
[1] 是，先运行 /docs（推荐）
[2] 否，跳过文档更新
[3] 取消本次提交

# 你选择 [1]
正在运行 /docs...
✅ 文档更新完成

继续提交代码和文档...
[main abc1234] feat: add binance spider
```

## 注意事项

1. **AI 生成的内容需要审核**：自动生成的文档可能不够准确，需要人工检查
2. **复杂逻辑需要手动完善**：自动更新只能处理标准情况，特殊逻辑需要手动补充
3. **保持文档风格一致**：AI 会尽量保持现有文档的风格和结构
4. **避免过度自动化**：重要的架构文档建议手动编写

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
