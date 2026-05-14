# Default Schema

本文件定义 `llm-wiki-stack` 在 bootstrap mode 下使用的默认知识库规则。

当 repo-local `AGENTS.md` 不存在时：
- `/kb-init` 以本文件作为默认 profile
- 其他日常动作不得继续执行，应提示先初始化

## Architecture

三层编译器架构：

```
01 raw/  ──编译──>  02 wiki/  ──对话──>  03 outputs/
(不可变源)           (概念网络)            (个人观点)
```

- **L1 raw**：源笔记，LLM 只读正文，可按权限规则修改 YAML frontmatter
- **L2 wiki**：概念页，LLM 维护，追踪概念演化
- **L3 outputs**：观点主题页 + 系统报告，用户主导，LLM 辅助

## Default Paths

- `raw_root = 01 raw`
- `wiki_root = 02 wiki`
- `output_root = 03 outputs`
- `template_root = 98 template`
- `assets_root = _assets`

## Bootstrap

`/kb-init` 假定用户只有大模型和一个目录，必须先做 dependency doctor：

- 检查 `git`、`rg`、基础 shell 工具和当前目录写权限
- `git` 与写权限为必需项；缺失时请求授权安装或提示用户处理
- `rg` 为推荐项；缺失时可回退到 `grep/find`

初始化流程：

1. 创建 `01 raw/`、`02 wiki/`、`03 outputs/`、`98 template/`
2. 用模板生成 `AGENTS.md`、`02 wiki/log.md`
3. 若 `01 raw/` 下存在 raw 文件，扫描并生成 `03 outputs/初始化提案.md`（列出建议创建的 wiki 概念页、重要度、链接关系）
4. **等待用户审阅确认**初始化提案
5. 用户确认后，调用 `/wiki-compile` 核心流水线，并传入全部合格 raw 文件的显式列表；`/kb-init` 不另写编译逻辑
6. 建立或补齐全局索引页和分区 map 页，确保概念页可从索引导航到达
7. 调用 `/wiki-lint` 机械检查作为完成门禁：未编译 raw、断链、frontmatter、raw_sources、双向回链、linked_count 和孤立节点必须检查
8. 输出 `03 outputs/初始化完成报告.md`，记录 raw 总数、已编译数、跳过项及原因、概念页数、map 页数和 lint 门禁结果
9. 初始化 git 和 `.gitignore`

## Page Types

wiki 和 outputs 页面统一使用最小 frontmatter：

| type | 所在层 | 说明 |
|------|--------|------|
| `source` | raw | 源笔记 |
| `entity` | wiki | 实体页——具体的人、组织、产品、岗位等可指名事物 |
| `concept` | wiki | 概念页——跨实体提炼的框架、原理、模式 |
| `map` | wiki | 分区导航页，簇识别与入口路由 |
| `log` | wiki | 追加式操作日志 |
| `output` | outputs | 观点主题页，question-driven 对话 |
| `health-report` | outputs | 月度体检报告 |

### concept 页 frontmatter

```yaml
type: concept
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
linked_count: 0
raw_sources: []
tags: []
```

linked_count 记录被其他 wiki 页和 outputs 页引用的次数，LLM 编译和创建主题时更新。

### entity 页 frontmatter

```yaml
type: entity
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
raw_sources: []
tags: []
```

实体页记录具体事物的事实信息（谁/什么、时间、关键属性），通过 `## 相关素材` 链接 raw 出处，`## 相关概念` 链接到解释该实体的概念页。实体页不包含 `## 当前理解` 和 `## 概念演化`——那是概念页的职责。

### output 页 frontmatter

```yaml
type: output
status: in-progress
created: YYYY-MM-DD
tags: []
```

## Raw Boundary

- 允许：移动目录、重命名文件、按主题重组层级
- 禁止：修改正文、增删原文段落、改写原始摘录含义
- 如需补充结构化信息，只写到 `02 wiki`

## Permission Model

raw 笔记采用三级权限：

| 区域 | 权限 | 说明 |
|------|------|------|
| 正文（标题、`## 即时思考`、`## 原文`） | **只读** | LLM 绝不修改 |
| YAML frontmatter | **可写，分级** | 见下方字段表 |
| 文件名 | **可建议** | LLM 仅可建议，不直接修改 |

### YAML 字段处理规则

| 字段 | 类型 | 处理 |
|------|------|------|
| `status` | 自动 | 缺失时设为 `processed`；已存在则不修改 |
| `type` | 自动 | 缺失时填入 `source` |
| `created` | 自动 | 缺失时取文件系统创建时间 |
| `source_url` | 推断 | 从正文查找链接补入 |
| `title` | 推断 | 缺则根据正文生成人类可读标题 |
| `tags` | 推断 | 提取 2-4 个主题标签 |
| 其他 | 手动 | 缺失不补，不猜测 |

来自外部渠道（剪藏、抓取）的无 YAML 笔记，LLM 在编译开始前自动生成最小 YAML 块并补全上述字段。

## Compilation Workflow (`/wiki-compile`)

`🔄 编译新素材` 是唯一将 raw 编译进 wiki 的入口，替代旧的 lightweight ingest 模式。

流程：

**文件选择**：
- 若用户指定了 raw 文件路径，直接编译
- 若由 `/kb-init` 调用，使用初始化阶段扫描并经用户确认的全部合格 raw 文件显式列表；只跳过交互式候选选择，不跳过后续编译门禁
- 若未指定，检测未编译 raw：收集 wiki 概念页 raw_sources 中已引用的路径，扫描 `01 raw/` 全量，找出不在已编译集合中的文件，呈现候选列表供用户确认
- 若候选列表为空，提示"当前无未编译 raw 文件"并退出

流程（对每个待编译文件）：
1. **文件名阻断检查**：文件名含随机字符串、与正文内容明显不符、或与已有文件冲突时，停止处理该文件，写入 `title: 建议标题` 到其 YAML，追加记录到 `03 outputs/待确认文件名.md`，提示用户处理后重新编译
2. **元数据补全**：按 Permission Model 规则补全缺失的 YAML 字段，正文永不修改
3. **实体提取**：从 raw 中提取关键实体和概念
4. **概念独立性测试**：创建新概念页前必须通过可定义性、单一核心和多重验证；单来源候选不创建独立页，只进入相关概念页或报告说明
5. **wiki 页创建/更新**，对每个实体/概念：
   - 无对应 wiki 页则基于 `concept.template.md` 创建
   - 已存在则默认**补充**新信息至 `## 阐述`，不覆盖 `## 当前理解`
   - **只有新信息明确纠正旧事实错误**时，将旧定义追加到 `## 概念演化`：`- (YYYY-MM) 旧理解摘要 [[01 raw/出处]]`，再更新 `## 当前理解`
   - **观点冲突**：列入 `## 不同理解`，并列双方时间与出处，不判定对错
6. 每条关键陈述附 `[[01 raw/...]]` 出处链接
7. 建立 wiki 间 `[[02 wiki/...]]` 双向链接
8. 交叉引用完整性检查：正文 raw 链接回填到 `raw_sources`，相关概念获得回链，`linked_count` 等于实际入链数
9. 更新受影响 wiki 页的 `linked_count`（=入链数）和 `updated`

编译完成后提交 git。

## Concept Evolution

wiki 概念页追踪观念生长全程，不覆盖历史。

**页面结构**：

```markdown
# {{概念名}}

## 当前理解
> 一句话核心定义，随认知演化更新

## 阐述
<!-- 整合来自不同 raw 的理解，每条关键陈述附 [[01 raw/...]] 出处 -->

## 不同理解
<!-- 若存在观点冲突，并列不同来源的视角与时间 -->

## 概念演化
<!-- - (YYYY-MM) 旧理解摘要 [[01 raw/出处]] -->

## 相关概念
<!-- [[02 wiki/...]] 双向链接 -->
```

**版本归档触发条件**：新素材明确纠正了旧事实错误。
**冲突记录触发条件**：不同来源对同一概念有不同理解，且无法判定对错。

默认假设新信息为补充，不因时间新就认为更好。

## Filename Blocking

防止随机 ID 文件名污染知识库。

触发条件（任一）：
- 文件名含随机字符串（如 `clip_20260506_1423.md`）
- 文件名与正文内容明显不符
- 与已有文件名冲突

阻断流程：
1. `/wiki-compile` 发现此类文件，停止处理
2. 在该 raw 的 YAML 写入 `title: 建议标题`
3. 追加记录到 `03 outputs/待确认文件名.md`
4. 提示用户："有 N 个文件待确认文件名，请处理后重新运行编译"
5. 用户处理完毕后再次触发编译，LLM 检查通过后继续

## Influence Weight

通过 `linked_count` 追踪概念被引用次数，定性区分核心与边缘。

- LLM 编译时更新受影响 wiki 页的 `linked_count`
- 在 outputs 对话和体检报告中定性使用：`被 outputs/ 引用` → 核心概念；`linked_count 低` → 边缘概念
- 默认不进行 PageRank 式递归计算，保持简单

## Health Check (`/wiki-lint`)

`🏥 月度体检` 目标：全库健康检查 + 结构化报告。

检查项：
- **断链**：所有 `[[...]]` 目标文件是否存在
- **孤儿页**：wiki 概念页是否被其他页面引用
- **空目录**：wiki、raw、outputs 下的空目录
- **frontmatter 完整性**：wiki/outputs 页面是否有 type/status/created/updated
- **linked_count 一致性**：声明的 linked_count vs 实际引用数
- **raw_sources 回填状态**：概念页正文引用了 raw 但 frontmatter raw_sources 为空
- **未编译 raw**：raw 文件未被任何 wiki 概念页的 raw_sources 引用

当 `/wiki-lint` 作为 `/kb-init` 完成门禁调用时，只执行机械检查和低风险自动修复；语义合并、主题创建和破坏性结构清理不得自动执行。

输出格式 `03 outputs/月度体检-YYYY-MM.md`，使用 `- [ ]` 任务列表：

- **概念演化一览**：本月发生理解更新的概念
- **脆弱依赖**：outputs 中观点依赖低 linked_count 概念的情况
- **孤岛节点**：linked_count 为 0 的 wiki 概念页
- **时间提示**：引用了已演化概念的 outputs 笔记

报告中定性使用影响力信息，不列具体数值。只输出建议，绝不自动创建主题页。

## Topic Workflow (`/wiki-topic`)

`🧠 新建主题` 是 question-driven 的观点形成流程，写入 `03 outputs/`。

核心原则：**先检索，再综合，后补全**。三个步骤的信息来源不同，必须在页面中清晰分界。

### 步骤 1 — 知识清单（只读，不生成观点）

从知识网络中检索所有相关节点，输出结构化清单，写入 `## 相关知识节点`：

- **直接相关**：匹配问题关键词的概念/实体页，提取核心定义、关键阐述、矛盾争议、关联 raw
- **可能相关**：已检查但不确定是否相关的概念，说明潜在关联点和排除理由
- **缺失**：wiki 层尚未覆盖的方向、有 raw 未被编译的笔记

约束：每个直接相关概念必须提取实质性信息，不得只列链接。可能相关和缺失不得为空（无缺口则说明"已覆盖"）。

### 步骤 2 — 基于知识库的综合

严格基于步骤 1 清单生成分析，写入 `## 基于知识库的分析`：

- 仅使用清单中已列出的概念和 raw
- 每条断言标注出处
- 矛盾观点并列呈现，不判定对错
- 禁止引入清单中未出现的新来源

### 步骤 3 — 模型补充

针对步骤 1 中"缺失"的内容，LLM 使用自有知识或外部工具补全，写入 `## 模型补充`：

- 与步骤 2 明确分界，不得混合
- 标注推理依据（模型训练知识 / 工具检索结果）
- 不重复步骤 2 已覆盖内容

### 步骤 4 — 对话与综合判断

- 用户主导后续对话，LLM 回应追问（均用 `🤖` 标记）
- 用户自行在 `✍️ 我的综合判断` 写下结论
- 相关 wiki 链接自动建立，`linked_count` 增加

LLM 权限：
- 可写入步骤 1-3 的输出区域和对话区自己的回复
- 对话区用户内容、`✍️ 我的综合判断` 只读
- 不替用户做综合判断

## Git Sync

实质变更后提交，不再有 off/major/on 模式切换。

实质变更定义：
- 发生了文件或目录的创建、删除、移动、重命名
- 修改命中了 `01 raw/**` 或 `02 wiki/**` 或 `03 outputs/**` 下的内容
- 结构初始化或 schema 级改动

不算实质变更：
- 纯错字修复
- 单页轻微措辞调整

commit message 格式：`ingest: <分区>`, `compile: <主题>`, `refactor: <范围>`, `lint: <范围>`, `fix: <问题>`

## Linking Rules

- raw 与 wiki 的关联统一用 Obsidian 链接维护
- 概念页必须列出 `raw_sources`，并在正文中链接关键来源
- 命名使用中文优先；概念页不带时间戳
- wiki 概念页之间通过 `## 相关概念` 双向链接
