# LLM Wiki Schema

本仓库采用知识库编译器三层结构：

- `raw sources`：`01 raw`
- `wiki`：`02 wiki`
- `outputs`：`03 outputs`
- `schema`：本文件 `AGENTS.md`

完整规则集参见 skill 内置的 `references/default-schema.md`。
本文件仅定义项目特定配置和增量规则；通用 compile / topic / lint 工作流以 default-schema.md 为准。

## 项目路径

- `raw_root = 01 raw`
- `wiki_root = 02 wiki`
- `output_root = 03 outputs`
- `template_root = 98 template`
- `assets_root = _assets`

## 项目特定规则

以下规则是对 default-schema.md 的补充或覆盖，优先级高于 default-schema.md。

### Raw Asset Rules

带图片、截图、音频、附件等本地资源的 raw，统一使用库根 `_assets/` 作为资源根目录。

- 本地资源统一保存到 `_assets/<raw 文件名去扩展名>/`
- 禁止为 raw 新建同级 `*.assets/`、`assets/` 或 `_assets/` 子目录
- raw 内本地图片链接必须使用从当前 raw 文件到库根 `_assets` 的相对路径
- 编译收尾必须确认本次新增 raw 的本地图片链接全部解析到实际文件

### Daily Memo Boundary

`00 daily memo/**` 是独立模块，不属于 `raw sources`，也不属于 `wiki`。

- 不要将 `00 daily memo` 视为编译输入
- 不要在 `02 wiki` 中链接、引用或沉淀 `00 daily memo` 的内容
- 不要把 `00 daily memo` 的页面登记到 wiki 的任何导航或索引中

### Git Scope

- 纳入 git：`01 raw/**`、`02 wiki/**`、`03 outputs/**`、`98 template/**`、`AGENTS.md`、必要的共享资源文件
- 不纳入 git：`00 daily memo/**`、`.obsidian/**`、`.DS_Store`、`*.icloud`、`.wiki-kb/**`

### Git Sync 约定

实质变更后提交。commit message 格式：

- `compile: <分区或主题>`
- `topic: <主题名>`
- `refactor: <页面或结构>`
- `lint: <修复范围>`
- `fix: <具体问题>`
- `init: <初始化步骤>`

提交粒度：一次知识库动作对应一次 commit。不要求把 commit hash 回写进页面。

### 编译工作流（项目增量）

在 default-schema.md 的编译流程之上：

- 编译不在此阶段创建 outputs 页（那是 `/wiki-topic` 的职责）
- 仅当 raw 满足"枢纽来源"条件且用户明确要求时，才创建单篇来源页
- 若本次编译涉及本地图片或附件，先确认资源已保存到 `_assets/<raw 文件名去扩展名>/`

### 主题页写作规则

`02 wiki/` 下概念页默认按"可复用结论页"来写：

- 语言风格：简练、客观、清晰，避免口语化废话和 AI 式套话
- 优先输出压缩后的判断、优先级和取舍
- 如果 raw 已提供具体数字、动作、例子，正文中至少吸收一个具体细节
- 能明确判断时直接写结论，不默认做两边都讲的中性综述
- 结构服务于内容，不为结构而结构

### 单篇来源页例外条件

以下情况可创建单篇来源页（需用户明确要求）：

- raw 本身非常长，内部已有多个可复用子结构
- 该 raw 预计会被高频反复引用
- 该 raw 属于会持续编译的系列内容
- 该 raw 能同时支撑多个概念页，具有"枢纽来源"角色

### Query Workflow

回答问题时优先使用 `02 wiki/` 概念页定位知识，再按需回读 raw。

- 若 wiki 层已经覆盖问题，优先基于 wiki 回答
- 若没有合适概念页，默认先停在 wiki 层；只有用户明确要求新建主题时，才通过 `/wiki-topic` 创建 outputs 页
- 只有在 wiki 缺失或需要核对原文时，才回读 raw
