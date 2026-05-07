---
name: wiki-lint
description: Subcommand of the `llm-wiki-stack` knowledge-base management framework. Lint an Obsidian knowledge base for orphan pages, duplicate topics, missing backlinks, misplaced raw files, empty source-index entries, and similar structural issues. Use when the user wants to run `/wiki-lint` directly.
---

# Wiki Lint

## Framework Binding

- This skill is one command adapter in the `llm-wiki-stack` framework.
- It does not define its own schema or workflow; it delegates to `../llm-wiki-stack/SKILL.md`.
- Repo-local `AGENTS.md` overrides both the core framework and this wrapper.

- This skill is a thin wrapper around `llm-wiki-stack`.
- First read `../llm-wiki-stack/SKILL.md` and follow the `/wiki-lint` command path only.
- Treat the user request as an explicit `/wiki-lint` invocation.
- Auto-fix low-risk mechanical issues (broken links, missing frontmatter); for semantic merges or destructive structural cleanup, follow the guardrails defined in the core skill.
- When user requests "月度体检" or "health check", generate a structured health report at `03 outputs/月度体检-YYYY-MM.md` with sections: concept evolution, fragile dependencies, orphan nodes, time hints, and suggested actions.
- Only output suggestions; never auto-create topic pages.
