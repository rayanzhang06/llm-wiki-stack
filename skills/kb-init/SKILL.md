---
name: kb-init
description: Subcommand of the `llm-wiki-stack` knowledge-base management framework. Initialize an Obsidian knowledge base from a raw-only or partially initialized directory. Use when the user wants to bootstrap the wiki structure, generate repo-local AGENTS.md, initialize git, or run `/kb-init` directly.
---

# KB Init

## Framework Binding

- This skill is one command adapter in the `llm-wiki-stack` framework.
- It does not define its own schema or workflow; it delegates to `../llm-wiki-stack/SKILL.md`.
- Repo-local `AGENTS.md` overrides both the core framework and this wrapper.

- This skill is a thin wrapper around `llm-wiki-stack`.
- First read `../llm-wiki-stack/SKILL.md` and follow the `/kb-init` command path only.
- Treat the user request as an explicit `/kb-init` invocation even if they do not mention `llm-wiki-stack`.
- Stay within bootstrap orchestration: create missing structure (including `03 outputs/`), generate local `AGENTS.md`, initialize git if needed, and keep the action idempotent.
- If `01 raw/` contains raw files, generate `03 outputs/初始化提案.md` listing suggested wiki concept pages and link relationships.
- Wait for user approval before batch compiling raw into wiki.
- After approval, reuse the core `/wiki-compile` pipeline with an explicit list of all eligible raw files. Do not invent a second compilation path inside this wrapper.
- Treat `/wiki-lint` mechanical checks as the completion gate for a full initialized knowledge base: uncompiled raw, broken links, frontmatter, raw_sources backfill, backlinks, and linked_count must be checked before writing `03 outputs/初始化完成报告.md`.
- Do not call `/wiki-topic` during initialization; initialization reports are system outputs, not question-driven topic pages.
