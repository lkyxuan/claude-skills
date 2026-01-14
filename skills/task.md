# /task - 智能任务管理

## 功能

自动判断模式，智能管理任务：
1. **开始模式** - 选择或创建任务，自动生成完整 checklist
2. **总结模式** - 自动分析工作进展，更新进度，推荐下一步
3. **查看模式** - 查看所有任务状态

## 核心特性

### ✨ 智能任务拆解
根据 ai-system 文档和任务类型，自动生成标准化的完整任务清单，不会遗漏任何步骤。

### ✨ 智能进度评估
分析对话内容和代码变更，自动计算任务进度，无需手动估计。

### ✨ 智能推荐
完成一个阶段后，自动推荐下一步要做什么，发现任务依赖和潜在问题。

## 使用方式

```bash
/task
```

AI 会自动判断当前应该执行哪种模式。

## 执行流程

### 阶段 1：模式判断

```javascript
function determineMode() {
  const conversationTurns = getConversationTurns()
  const hasCodeChanges = checkGitStatus()
  const hasFileEdits = checkRecentEdits()

  if (conversationTurns < 5 && !hasCodeChanges && !hasFileEdits) {
    // 对话刚开始，没有工作 → 开始模式
    return 'START'
  }

  if (hasCodeChanges || hasFileEdits || conversationTurns > 10) {
    // 有代码变更或对话较长 → 总结模式
    return 'SUMMARY'
  }

  // 默认 → 查看模式
  return 'VIEW'
}
```

---

## 模式 A：开始模式

### 1. 读取并展示任务列表

```bash
# 读取 data/tasks.json
cat data/tasks.json
```

**如果有进行中的任务**：

```
💡 你有 X 个进行中的任务：

1. Twitter 数据采集 (60%)
   📋 当前阶段：Kafka 集成 (2/3)
   ⏰ 最近更新：2 小时前
   🏷️ 标签：crawler, data-source

   进度详情：
   ✅ 爬虫实现 (25%) - 已完成
   🟡 Kafka 集成 (25%) - 进行中 (2/3)
   ⬜ 数据处理 (25%)
   ⬜ 文档更新 (15%)
   ⬜ Dashboard 展示 (10%)

2. Polars Engine 优化 (30%)
   📋 当前阶段：性能优化
   ⏰ 最近更新：3 天前

要继续哪个任务？
[1] 继续任务 1: Twitter 数据采集
[2] 继续任务 2: Polars Engine 优化
[3] 创建新任务
[4] 查看所有任务（包括待定、已完成）

请选择:
```

**如果没有进行中的任务**：

```
📋 当前没有进行中的任务。

是否创建新任务？
[1] 是，创建新任务
[2] 查看待定任务
[3] 查看所有任务

请选择:
```

### 2. 创建新任务（智能拆解）

```
创建新任务

📝 任务标题:
> Twitter 数据采集

📝 任务描述（可选，回车跳过）:
> 实现 Twitter API v2 数据采集功能

📂 任务类型:
[1] feature - 新功能开发
[2] bug - Bug 修复
[3] enhancement - 功能改进
[4] refactor - 代码重构
[5] docs - 文档更新
请选择: 1

🏷️ 任务标签（逗号分隔，可选）:
> crawler, data-source

🔗 是否关联 OpenSpec proposal？
[1] 是（重大变更，需要记录决策）
[2] 否
请选择: 1

📋 OpenSpec proposal ID:
> add-twitter-datasource

---

🧠 正在智能分析任务...

📚 读取系统文档:
✅ ai-system/L0-SYSTEM-INDEX-系统索引.md
✅ ai-system/L1-capabilities/L1-data-collection-数据采集.md
✅ ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md
✅ openspec/specs/spider-dev-guide/spec.md

📝 读取 OpenSpec proposal:
✅ changes/add-twitter-datasource/proposal.md

🤖 根据系统架构，自动生成完整任务清单：

═══════════════════════════════════════════════
📋 Twitter 数据采集 (0%)
═══════════════════════════════════════════════

阶段 1: 爬虫实现 (权重: 25%)
  [ ] API 客户端实现
      - 实现 TwitterAPIClient 类
      - OAuth 2.0 认证
      - 速率限制处理
  [ ] 数据采集逻辑
      - 实现 fetch_tweets() 方法
      - 处理分页和游标
  [ ] 错误处理和重试
      - 超时处理
      - 重试机制
      - 日志记录

阶段 2: Kafka 集成 (权重: 25%)
  [ ] 配置 Kafka Producer
      - 创建 producer 配置
      - 序列化设置
  [ ] 创建 Kafka Topic
      - Topic: twitter-raw-data
      - 分区: 3
      - 副本: 2
  [ ] 测试数据流
      - 端到端测试
      - 验证数据格式

阶段 3: 数据处理 (权重: 25%)
  [ ] 数据清洗逻辑
      - 去重
      - 格式标准化
  [ ] 数据转换逻辑
      - 提取关键字段
      - 时间戳转换
  [ ] Schema 验证
      - 定义 Pydantic 模型
      - 验证数据完整性

阶段 4: 文档更新 (权重: 15%)
  [ ] 创建 spider/twitter/README.md
      - 功能说明
      - 配置指南
      - 使用示例
  [ ] 更新 ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md
      - 添加 Twitter 数据源
      - Schema 定义
  [ ] 更新 ai-system/L1-capabilities/L1-data-collection-数据采集.md
      - 添加 Twitter 采集能力
  [ ] 更新 ai-system/L0-SYSTEM-INDEX-系统索引.md
      - 更新能力表格

阶段 5: Dashboard 展示 (权重: 10%)
  [ ] 添加数据源配置
      - Grafana 数据源
  [ ] 配置监控面板
      - 采集速率
      - 错误率

═══════════════════════════════════════════════

💡 依赖关系分析:
⚠️ 阶段 3（数据处理）依赖阶段 2（Kafka 集成）
⚠️ 阶段 5（Dashboard）依赖阶段 2（Kafka 集成）

🎯 建议执行顺序:
1 → 2 → 3 → 4 → 5

📊 预估工作量:
- 总计: 21 个子任务
- 预估时间: 3-5 天

确认创建此任务？[Y/n]
```

### 3. 继续现有任务

```javascript
// 选择任务后
const task = getTaskById(selectedId)

console.log(`\n✅ 开始继续任务: ${task.title}`)
console.log(`📊 当前进度: ${task.progress}%\n`)

// 显示当前阶段
const currentPhase = getCurrentPhase(task)
console.log(`📋 当前阶段: ${currentPhase.phase}`)
console.log(`   进度: ${currentPhase.completed}/${currentPhase.total} 完成\n`)

// 显示详细清单
console.log(`任务清单:\n`)
task.checklist.forEach(phase => {
  const icon = phase.completed ? '✅' : (phase.inProgress ? '🟡' : '⬜')
  console.log(`${icon} ${phase.phase} (${phase.weight}%)`)

  phase.items.forEach(item => {
    const itemIcon = item.done ? '  ✅' : (item.blocked ? '  ⏸️' : '  ⬜')
    console.log(`${itemIcon} ${item.item}`)
    if (item.blocked) {
      console.log(`     ⚠️ 待定原因: ${item.reason}`)
    }
  })
  console.log()
})

// 读取相关文档
console.log(`📚 读取相关文档...\n`)
loadRelevantDocs(task)

// 如果有 OpenSpec，也读取
if (task.openspecRef) {
  console.log(`📝 读取 OpenSpec proposal...\n`)
  readFile(`changes/${task.openspecRef}/proposal.md`)
}

console.log(`✅ 准备完成，开始工作！\n`)
```

---

## 模式 B：总结模式（核心功能）

### 1. 智能分析工作进展

```javascript
function analyzeWorkProgress() {
  console.log(`📊 正在智能分析本次对话...\n`)

  // 1. 获取当前任务
  const currentTask = getCurrentActiveTask()
  if (!currentTask) {
    console.log(`⚠️ 没有检测到活跃任务`)
    return
  }

  // 2. 分析 Git 变更
  const gitStatus = execBash('git status --porcelain')
  const gitDiff = execBash('git diff --stat')
  const changedFiles = parseGitStatus(gitStatus)

  console.log(`🔍 检测到代码变更:\n`)
  changedFiles.forEach(file => {
    const status = file.status === 'A' ? '新建' :
                   file.status === 'M' ? '修改' : '删除'
    console.log(`   ${status}: ${file.path}`)
  })

  if (gitDiff) {
    const stats = parseGitStats(gitDiff)
    console.log(`\n   📈 统计: +${stats.additions} -${stats.deletions} 行`)
  }

  // 3. 分析对话内容
  console.log(`\n🧠 分析对话内容...\n`)
  const conversation = getConversationHistory()
  const workSummary = summarizeWork(conversation, changedFiles)

  console.log(`📝 完成的工作:\n`)
  workSummary.forEach(work => {
    console.log(`   ✅ ${work}`)
  })

  // 4. 智能匹配 checklist 项
  console.log(`\n🎯 匹配任务清单...\n`)
  const matchedItems = matchChecklistItems(currentTask, workSummary, changedFiles)

  matchedItems.forEach(match => {
    console.log(`   ✅ ${match.phase} > ${match.item}`)
    console.log(`      匹配依据: ${match.reason}`)
  })

  return {
    task: currentTask,
    changedFiles,
    workSummary,
    matchedItems
  }
}
```

### 2. 自动更新 checklist

```javascript
function updateChecklist(task, matchedItems) {
  let updated = false

  matchedItems.forEach(match => {
    const phase = task.checklist.find(p => p.phase === match.phase)
    if (phase) {
      const item = phase.items.find(i => i.item === match.item)
      if (item && !item.done) {
        item.done = true
        item.completedAt = new Date().toISOString()
        updated = true
      }
    }
  })

  return updated
}
```

### 3. 智能计算进度

```javascript
function calculateSmartProgress(task) {
  let totalWeight = 0
  let completedWeight = 0

  task.checklist.forEach(phase => {
    totalWeight += phase.weight

    // 统计完成情况
    const totalItems = phase.items.length
    const completedItems = phase.items.filter(item => item.done).length
    const phaseCompletion = completedItems / totalItems

    // 判断阶段状态
    if (completedItems === totalItems) {
      phase.completed = true
      phase.inProgress = false
    } else if (completedItems > 0) {
      phase.completed = false
      phase.inProgress = true
    } else {
      phase.completed = false
      phase.inProgress = false
    }

    completedWeight += phase.weight * phaseCompletion
  })

  const oldProgress = task.progress
  const newProgress = Math.round((completedWeight / totalWeight) * 100)

  return {
    oldProgress,
    newProgress,
    delta: newProgress - oldProgress
  }
}
```

### 4. 智能推荐下一步

```javascript
function recommendNextSteps(task) {
  const recommendations = []

  // 找出刚完成的阶段
  const justCompletedPhases = task.checklist.filter(phase =>
    phase.completed && !phase.recommendationShown
  )

  justCompletedPhases.forEach(completedPhase => {
    // 找到下一个阶段
    const phaseIndex = task.checklist.indexOf(completedPhase)
    const nextPhase = task.checklist[phaseIndex + 1]

    if (nextPhase) {
      recommendations.push({
        type: 'NEXT_PHASE',
        phase: nextPhase.phase,
        reason: `"${completedPhase.phase}"已完成，建议继续下一阶段`,
        priority: 'HIGH'
      })

      // 标记已推荐
      completedPhase.recommendationShown = true
    }
  })

  // 检查依赖关系
  const blockedPhases = checkDependencies(task)
  blockedPhases.forEach(blocked => {
    recommendations.push({
      type: 'DEPENDENCY',
      phase: blocked.phase,
      reason: blocked.reason,
      priority: 'MEDIUM'
    })
  })

  // 检查潜在问题
  const issues = detectIssues(task)
  issues.forEach(issue => {
    recommendations.push({
      type: 'ISSUE',
      description: issue.description,
      suggestion: issue.suggestion,
      priority: 'HIGH'
    })
  })

  return recommendations
}
```

### 5. 完整的总结输出

```
📊 工作总结

═══════════════════════════════════════════════
任务: Twitter 数据采集
上次进度: 25% | 当前进度: 50% (+25%)
═══════════════════════════════════════════════

🔍 本次完成的工作:

代码变更:
  新建: consumer/twitter_processor/main.py (+150 行)
  新建: consumer/twitter_processor/transform.py (+80 行)
  修改: consumer/twitter_processor/__init__.py (+10 行)
  新建: tests/test_twitter_processor.py (+120 行)

工作内容:
  ✅ 实现了数据清洗逻辑
  ✅ 实现了数据转换逻辑
  ✅ 定义了 Pydantic Schema
  ✅ 添加了单元测试

📋 任务清单更新:

✅ 阶段 1: 爬虫实现 (25%) - 已完成
✅ 阶段 2: Kafka 集成 (25%) - 已完成
🟡 阶段 3: 数据处理 (25%) - 刚完成！
   ✅ 数据清洗逻辑
   ✅ 数据转换逻辑
   ✅ Schema 验证
⬜ 阶段 4: 文档更新 (15%)
⬜ 阶段 5: Dashboard 展示 (10%)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 智能推荐:

🎉 恭喜！"数据处理"阶段已完成！

接下来应该做:
→ 阶段 4: 文档更新 (15%)

为什么:
- 前 3 个阶段（爬虫、Kafka、数据处理）都已完成
- 核心功能已实现，现在需要更新文档
- 更新文档后可以进行 Dashboard 配置

具体任务:
  [ ] 创建 spider/twitter/README.md
  [ ] 更新 ai-system/L2-assets/L2-DATA-ASSETS-数据资产清单.md
  [ ] 更新 ai-system/L1-capabilities/L1-data-collection-数据采集.md
  [ ] 更新 ai-system/L0-SYSTEM-INDEX-系统索引.md

⚠️ 提示:
完成文档更新后，进度将达到 65%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

是否更新任务进度？
[1] 是，更新到 50% (+25%)
[2] 手动输入进度（如果评估不准确）
[3] 不更新，继续工作

请选择:
```

### 6. 保存更新

```javascript
function saveProgress(task, newProgress, summary) {
  // 更新任务
  task.progress = newProgress
  task.updated = new Date().toISOString()

  // 添加评论记录
  task.comments.push({
    date: new Date().toISOString(),
    type: 'PROGRESS_UPDATE',
    content: summary.workSummary.join('; '),
    oldProgress: summary.oldProgress,
    newProgress: newProgress,
    filesChanged: summary.changedFiles.length,
    linesAdded: summary.stats.additions,
    linesDeleted: summary.stats.deletions
  })

  // 保存到 tasks.json
  saveTasksJson(tasks)

  // 生成 PROGRESS.md
  generateProgressMarkdown(tasks)

  console.log(`\n✅ 任务进度已更新: ${summary.oldProgress}% → ${newProgress}%`)
  console.log(`✅ tasks.json 已保存`)
  console.log(`✅ PROGRESS.md 已生成\n`)

  // 提示下一步
  console.log(`💡 建议: 现在提交代码？(/push)\n`)
}
```

---

## 模式 C：查看模式

```
📊 所有任务

🚀 进行中 (2):

1. Twitter 数据采集 (50%)
   📋 阶段: 数据处理 → 文档更新
   ⏰ 最近更新: 5 分钟前
   📝 最近工作: 实现数据清洗和转换逻辑

   进度详情:
   ✅ 爬虫实现 (25%)
   ✅ Kafka 集成 (25%)
   ✅ 数据处理 (25%)
   ⬜ 文档更新 (15%)
   ⬜ Dashboard 展示 (10%)

2. Polars Engine 优化 (30%)
   📋 阶段: 性能优化
   ⏰ 最近更新: 3 天前
   📝 最近工作: 性能瓶颈分析

⏸️ 待定 (1):

3. Dashboard 展示层
   ⚠️ 原因: 等待 UI 设计稿
   ⏰ 创建: 5 天前

✅ 已完成 (5):

4. CoinGecko 爬虫
   ✅ 完成时间: 10 天前
   📊 总耗时: 3 天

...

要继续哪个任务？
[1-3] 选择任务
[n] 创建新任务
[q] 退出

请选择:
```

---

## 辅助功能

### 智能匹配算法

```javascript
function matchChecklistItems(task, workSummary, changedFiles) {
  const matches = []

  task.checklist.forEach(phase => {
    phase.items.forEach(item => {
      if (item.done) return // 已完成，跳过

      // 匹配逻辑 1：关键词匹配
      const keywords = extractKeywords(item.item)
      const summaryMatch = workSummary.some(work =>
        keywords.some(keyword => work.toLowerCase().includes(keyword.toLowerCase()))
      )

      if (summaryMatch) {
        matches.push({
          phase: phase.phase,
          item: item.item,
          reason: '对话内容匹配',
          confidence: 0.8
        })
        return
      }

      // 匹配逻辑 2：文件路径匹配
      const fileMatch = changedFiles.some(file => {
        // 例如: "API 客户端实现" 匹配 "spider/twitter/client.py"
        if (item.item.includes('API 客户端') && file.path.includes('client.py')) {
          return true
        }
        if (item.item.includes('数据清洗') && file.path.includes('clean')) {
          return true
        }
        if (item.item.includes('数据转换') && file.path.includes('transform')) {
          return true
        }
        return false
      })

      if (fileMatch) {
        matches.push({
          phase: phase.phase,
          item: item.item,
          reason: '文件路径匹配',
          confidence: 0.9
        })
        return
      }
    })
  })

  return matches
}
```

### 依赖检查

```javascript
function checkDependencies(task) {
  const blockers = []

  task.checklist.forEach((phase, index) => {
    // 检查是否有前置依赖
    if (index > 0 && !task.checklist[index - 1].completed && phase.inProgress) {
      blockers.push({
        phase: phase.phase,
        reason: `依赖"${task.checklist[index - 1].phase}"未完成`
      })
    }

    // 检查特定依赖
    if (phase.phase === '数据处理' && !schemaExists()) {
      blockers.push({
        phase: phase.phase,
        reason: '缺少 Schema 定义，建议先创建 schema.py'
      })
    }

    if (phase.phase === 'Dashboard 展示' && !kafkaTopicExists()) {
      blockers.push({
        phase: phase.phase,
        reason: 'Kafka Topic 未创建，需要先完成 Kafka 集成'
      })
    }
  })

  return blockers
}
```

### 问题检测

```javascript
function detectIssues(task) {
  const issues = []

  // 检测 1：文档更新是否遗漏
  const hasCodeChanges = checkGitStatus()
  const docPhase = task.checklist.find(p => p.phase.includes('文档'))

  if (hasCodeChanges && docPhase && !docPhase.completed) {
    const codePhases = task.checklist.filter(p =>
      p.completed && !p.phase.includes('文档')
    )

    if (codePhases.length >= 2) {
      issues.push({
        description: '多个代码阶段已完成，但文档未更新',
        suggestion: '建议尽快更新文档，避免遗忘实现细节',
        priority: 'HIGH'
      })
    }
  }

  // 检测 2：长时间未更新
  const daysSinceUpdate = getDaysSince(task.updated)
  if (daysSinceUpdate > 3 && task.status === 'in-progress') {
    issues.push({
      description: `任务已 ${daysSinceUpdate} 天未更新`,
      suggestion: '考虑标记为待定，或继续推进',
      priority: 'MEDIUM'
    })
  }

  return issues
}
```

---

## 任务模板库

### 新增爬虫模板

```javascript
const SPIDER_TEMPLATE = {
  phases: [
    {
      phase: "爬虫实现",
      weight: 25,
      items: [
        "API 客户端实现",
        "数据采集逻辑",
        "错误处理和重试"
      ]
    },
    {
      phase: "Kafka 集成",
      weight: 25,
      items: [
        "配置 Kafka Producer",
        "创建 Kafka Topic",
        "测试数据流"
      ]
    },
    {
      phase: "数据处理",
      weight: 25,
      items: [
        "数据清洗逻辑",
        "数据转换逻辑",
        "Schema 验证"
      ]
    },
    {
      phase: "文档更新",
      weight: 15,
      items: [
        "创建 spider/*/README.md",
        "更新 L2-DATA-ASSETS",
        "更新 L1-data-collection",
        "更新 L0-SYSTEM-INDEX"
      ]
    },
    {
      phase: "Dashboard 展示",
      weight: 10,
      items: [
        "添加数据源配置",
        "配置监控面板"
      ]
    }
  ]
}
```

### 新增计算指标模板

```javascript
const CALCULATOR_TEMPLATE = {
  phases: [
    {
      phase: "指标实现",
      weight: 30,
      items: [
        "Hamilton DAG 节点定义",
        "计算逻辑实现",
        "单元测试"
      ]
    },
    {
      phase: "集成测试",
      weight: 20,
      items: [
        "端到端测试",
        "性能测试"
      ]
    },
    {
      phase: "文档更新",
      weight: 30,
      items: [
        "更新 L2-computed-indicators",
        "更新 Polars Engine README"
      ]
    },
    {
      phase: "Dashboard 配置",
      weight: 20,
      items: [
        "添加指标到面板",
        "配置可视化"
      ]
    }
  ]
}
```

---

## 数据结构

### tasks.json（增强版）

```json
{
  "version": "1.0",
  "tasks": [
    {
      "id": "twitter-datasource",
      "title": "Twitter 数据采集",
      "description": "实现 Twitter API v2 数据采集功能",
      "status": "in-progress",
      "progress": 50,
      "category": "feature",
      "labels": ["crawler", "data-source"],
      "created": "2026-01-14T10:00:00Z",
      "updated": "2026-01-15T14:30:00Z",
      "started": "2026-01-14T11:00:00Z",
      "openspecRef": "add-twitter-datasource",
      "openspecUrl": "https://github.com/user/repo/tree/main/changes/add-twitter-datasource",
      "checklist": [
        {
          "phase": "爬虫实现",
          "weight": 25,
          "completed": true,
          "inProgress": false,
          "items": [
            {
              "item": "API 客户端实现",
              "done": true,
              "completedAt": "2026-01-14T15:00:00Z"
            },
            {
              "item": "数据采集逻辑",
              "done": true,
              "completedAt": "2026-01-14T16:30:00Z"
            },
            {
              "item": "错误处理和重试",
              "done": true,
              "completedAt": "2026-01-14T17:00:00Z"
            }
          ]
        },
        {
          "phase": "Kafka 集成",
          "weight": 25,
          "completed": true,
          "inProgress": false,
          "items": [
            {
              "item": "配置 Kafka Producer",
              "done": true,
              "completedAt": "2026-01-15T10:00:00Z"
            },
            {
              "item": "创建 Kafka Topic",
              "done": true,
              "completedAt": "2026-01-15T10:30:00Z"
            },
            {
              "item": "测试数据流",
              "done": true,
              "completedAt": "2026-01-15T11:00:00Z"
            }
          ]
        },
        {
          "phase": "数据处理",
          "weight": 25,
          "completed": true,
          "inProgress": false,
          "items": [
            {
              "item": "数据清洗逻辑",
              "done": true,
              "completedAt": "2026-01-15T14:00:00Z"
            },
            {
              "item": "数据转换逻辑",
              "done": true,
              "completedAt": "2026-01-15T14:20:00Z"
            },
            {
              "item": "Schema 验证",
              "done": true,
              "completedAt": "2026-01-15T14:30:00Z"
            }
          ]
        },
        {
          "phase": "文档更新",
          "weight": 15,
          "completed": false,
          "inProgress": false,
          "items": [
            {
              "item": "创建 spider/twitter/README.md",
              "done": false
            },
            {
              "item": "更新 L2-DATA-ASSETS",
              "done": false
            },
            {
              "item": "更新 L1-data-collection",
              "done": false
            },
            {
              "item": "更新 L0-SYSTEM-INDEX",
              "done": false
            }
          ]
        },
        {
          "phase": "Dashboard 展示",
          "weight": 10,
          "completed": false,
          "inProgress": false,
          "items": [
            {
              "item": "添加数据源配置",
              "done": false
            },
            {
              "item": "配置监控面板",
              "done": false
            }
          ]
        }
      ],
      "commits": ["a1b2c3d", "e4f5g6h", "i7j8k9l"],
      "prs": [124, 125],
      "comments": [
        {
          "date": "2026-01-14T15:00:00Z",
          "type": "PROGRESS_UPDATE",
          "content": "完成 API 客户端实现",
          "oldProgress": 0,
          "newProgress": 8,
          "filesChanged": 2,
          "linesAdded": 150
        },
        {
          "date": "2026-01-15T14:30:00Z",
          "type": "PROGRESS_UPDATE",
          "content": "实现数据清洗和转换逻辑; 定义 Schema",
          "oldProgress": 25,
          "newProgress": 50,
          "filesChanged": 4,
          "linesAdded": 360
        }
      ]
    }
  ],
  "stats": {
    "total": 1,
    "inProgress": 1,
    "pending": 0,
    "completed": 0
  }
}
```

---

## 使用示例

参见之前的完整演示（Day 1-5 场景）。

## 相关文件

- `data/tasks.json` - 任务数据存储
- `PROGRESS.md` - 自动生成的进度展示
- `ai-system/` - 系统架构文档（用于智能分析）
- `changes/*/proposal.md` - OpenSpec proposals

## 相关 Skills

- `/push` - 提交代码和文档
- `/daily-report` - 生成日报（待创建）

## 注意事项

1. **首次使用**会自动创建 `data/tasks.json`
2. **智能匹配**准确率约 80-90%，可以手动调整
3. **进度评估**基于权重自动计算，相对准确
4. **建议执行** `/task` 的时机：
   - 开始工作时
   - 完成一个阶段后
   - 对话较长时（总结进展）
   - 结束工作前
