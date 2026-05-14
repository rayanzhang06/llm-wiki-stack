---
name: wiki-compile
description: Subcommand of the `llm-wiki-stack` knowledge-base management framework. Compile one or more raw source files into the Obsidian wiki layer, including metadata completion, concept extraction, backlink repair, raw_sources backfill, and linked_count updates. Use when the user wants to run `/wiki-compile` directly or compile uncompiled raw files.
---

# Wiki Compile

## Framework Binding

- This skill is one command adapter in the `llm-wiki-stack` framework.
- It does not define its own schema or workflow; it delegates to `../llm-wiki-stack/SKILL.md`.
- Repo-local `AGENTS.md` overrides both the core framework and this wrapper.

- This skill is a thin wrapper around `llm-wiki-stack`.
- First read `../llm-wiki-stack/SKILL.md` and follow the `/wiki-compile` command path only.
- Treat the user request as an explicit `/wiki-compile` invocation.
- `/wiki-compile` is the only raw-to-wiki compilation path. Do not use `raw-ingest` or a lightweight ingest shortcut for compilation.
- If explicit raw paths are provided, compile only those paths. If no paths are provided, follow the core uncompiled-raw detection and confirmation flow.
- When invoked from `/kb-init`, accept the explicit all-eligible-raw list supplied by initialization and skip only the interactive candidate-selection step; do not skip filename blocking, metadata completion, concept independence tests, backlink repair, `raw_sources` backfill, or `linked_count` updates.
