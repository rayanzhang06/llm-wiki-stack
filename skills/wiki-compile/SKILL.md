---
name: wiki-compile
description: Subcommand of the `llm-wiki-stack` knowledge-base management framework. Compile user-specified or uncompiled raw files into the wiki layer with concept evolution, metadata completion, and linked_count tracking. Use when the user wants to run `/wiki-compile` or `🔄 编译新素材`.
---

# Wiki Compile

## Framework Binding

- This skill is one command adapter in the `llm-wiki-stack` framework.
- It does not define its own schema or workflow; it delegates to `../llm-wiki-stack/SKILL.md`.
- Repo-local `AGENTS.md` overrides both the core framework and this wrapper.

- This skill is a thin wrapper around `llm-wiki-stack`.
- First read `../llm-wiki-stack/SKILL.md` and follow the `/wiki-compile` command path only.
- Treat the user request as an explicit `/wiki-compile` invocation.
- Run the full compilation pipeline: determine target files (user-specified or auto-detect uncompiled) → filename check → metadata completion → entity extraction → concept independence test → wiki page creation/update with concept evolution → cross-reference integrity check → linked_count maintenance.
