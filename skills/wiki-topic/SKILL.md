---
name: wiki-topic
description: Subcommand of the `llm-wiki-stack` knowledge-base management framework. Query, synthesize, create, or update a topic page inside an Obsidian knowledge base. Use when the user wants to run `/wiki-topic` directly to update a topic page, infer a topic target, or create a new reusable topic page when explicitly needed.
---

# Wiki Topic

## Framework Binding

- This skill is one command adapter in the `llm-wiki-stack` framework.
- It does not define its own schema or workflow; it delegates to `../llm-wiki-stack/SKILL.md`.
- Repo-local `AGENTS.md` overrides both the core framework and this wrapper.

- This skill is a thin wrapper around `llm-wiki-stack`.
- First read `../llm-wiki-stack/SKILL.md` and follow the `/wiki-topic` command path only.
- Treat the user request as an explicit `/wiki-topic` invocation.
- New topic pages go into `03 outputs/` with `type: output`. Use question-driven flow: user asks a question → LLM provides initial analysis → dialogue → user writes judgment.
- Resolve the target topic according to the core skill rules: prefer an explicit page, then an inferred reusable page, and only create a new page when an existing one cannot naturally absorb the content.
