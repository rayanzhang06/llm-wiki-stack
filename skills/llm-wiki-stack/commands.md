# llm-wiki-stack Command Manifest

Framework: `llm-wiki-stack`

## Spec Mapping

| 命令 | 规格书动作 |
|------|-----------|
| `/kb-init` | `🏗️ 初始化知识库` |
| `/wiki-compile` | `🔄 编译新素材` |
| `/wiki-topic` | `🧠 新建主题` |
| `/wiki-lint` | `🏥 月度体检` |

（`📄 新建源笔记` 由 Obsidian QuickAdd + 模板完成，非 LLM 命令）

## Command Adapters

- `kb-init` -> bootstrap workflow
- `wiki-compile` -> compilation pipeline
- `wiki-topic` -> topic workflow (outputs layer)
- `wiki-lint` -> lint + health check workflow

## Rule Hierarchy

1. repo-local `AGENTS.md`
2. `llm-wiki-stack/SKILL.md`
3. `llm-wiki-stack/references/default-schema.md`

## Interpretation Rules

- 这些 wrapper 属于同一个知识库管理框架，不是彼此独立的 skill。
- wrapper 不定义自己的 schema；它们只把用户请求映射到 core skill 的某一个命令入口。
- 若 wrapper 文案与 core skill 或 repo-local `AGENTS.md` 冲突，以更高层规则为准。
- `/wiki-compile` 是唯一将 raw 编译进 wiki 的入口，不再有独立的 lightweight ingest。
- `/kb-init` 是编排入口：初始化骨架后复用 core `/wiki-compile` 流水线编译全部合格 raw，并用 `/wiki-lint` 机械检查作为完成门禁；不得调用 `/wiki-topic` 生成初始化报告。
