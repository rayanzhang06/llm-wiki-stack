English | [中文](README_ZH.md)

# llm-wiki-stack

Obsidian-based knowledge base compiler. Turns fragmented source notes into an interconnected concept network, powered by LLM compilation.

## Philosophy

Most note systems are **warehouses** — you put things in. This is a **compiler** — it transforms raw material into structured, queryable knowledge.

```
01 raw/  ──compile──>  02 wiki/  ──dialogue──>  03 outputs/
(source of truth)      (concept network)          (your opinions)
```

**Knowledge compiled once, precipitates continuously, compounding over time.**

## Install

```bash
npx llm-wiki-stack
```

Copies 5 skills into `~/.claude/skills/`. Ready to use in Claude Code.

## Commands

| Command | Action | When |
|---------|--------|------|
| `/kb-init` | Bootstrap a knowledge base from scratch | Once per vault |
| `/wiki-compile` | Compile new raw notes into wiki | After collecting source material |
| `/wiki-topic` | Question-driven opinion formation | When you have a research question |
| `/wiki-lint` | Health check + structured report | Monthly |

## How It Works

1. **Collect** — Save articles, thoughts, clippings into `01 raw/` with `status: inbox`
2. **Compile** — Run `/wiki-compile`; LLM extracts concepts, creates wiki pages, builds cross-references
3. **Think** — Run `/wiki-topic` with a question; LLM reveals structural relationships between concepts
4. **Maintain** — Run `/wiki-lint` monthly; LLM surfaces orphan nodes, fragile dependencies, concept evolution

## Key Mechanisms

**Concept Independence Test** — Before creating a new wiki page, every candidate concept must pass:
- Definability: can you clearly state what this concept *is* in 1-2 sentences?
- Single core: is it one concept, or "A and B" glued together?
- Multi-source verification: does it appear in at least two different source notes?

**Concept Evolution** — No overwrites. Understanding changes are tracked in a versioned timeline. Default behavior is *append*, not replace.

**Cross-Reference Integrity** — Every claim links to its raw source. Every wiki link is bidirectional. Linked counts are verified on each compile.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) or compatible AI agent

## License

MIT
