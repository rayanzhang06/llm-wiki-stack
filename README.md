English | [中文](README_ZH.md)

# llm-wiki-stack

[![npm version](https://img.shields.io/npm/v/llm-wiki-stack)](https://www.npmjs.com/package/llm-wiki-stack)
[![npm downloads](https://img.shields.io/npm/dt/llm-wiki-stack)](https://www.npmjs.com/package/llm-wiki-stack)
[![license](https://img.shields.io/npm/l/llm-wiki-stack)](LICENSE)

**Turn fragmented reading into a growing concept network.** An Obsidian knowledge base compiler that transforms raw source notes into structured, linked, queryable knowledge — maintained by LLMs, driven by your questions.

---

## The Problem

You read. You bookmark. You clip. You highlight. Months later, you have hundreds of notes but can't find what you need. When you do find something, you can't remember how it connects to everything else. Your notes are a pile, not a network.

Most PKM tools solve the *writing* problem. They don't solve the *synthesis* problem — the work of connecting, reconciling, and evolving your understanding across dozens or hundreds of sources.

**llm-wiki-stack solves the synthesis problem.**

## How It Works

Think of it as a **compiler** for knowledge. Source notes go in, a structured concept network comes out.

```
01 raw/   ──compile──>  02 wiki/   ──dialogue──>  03 outputs/
(source notes)          (concept network)           (your opinions)
```

Each layer has a clear role:

| Layer | Owned by | What happens |
|-------|----------|--------------|
| `01 raw/` | **You** | Save articles, clippings, thoughts. LLM never touches the body text. |
| `02 wiki/` | **LLM** | Extracts concepts, tracks how your understanding evolves, builds bidirectional links |
| `03 outputs/` | **You + LLM** | You ask questions. LLM reveals structural relationships. You write the conclusion. |

The result: every concept has a page. Every page links to its sources. Every source is traceable. Every change in understanding is recorded.

## Quick Start

```bash
npx llm-wiki-stack
```

This installs the five commands below into `~/.claude/skills/`. Then open Claude Code in your Obsidian vault and:

1. **Once**: `/kb-init` — bootstraps the three-layer structure
2. **Often**: `/wiki-compile` — turns your raw notes into linked wiki pages
3. **When curious**: `/wiki-topic` — ask a question, get a structured analysis from your own notes
4. **Monthly**: `/wiki-lint` — health report: orphan concepts, fragile dependencies, evolution timeline

Stop there. You'll know if this is for you.

## Commands

| Command | Role | Action |
|---------|------|--------|
| `/kb-init` | Architect | Bootstrap vault structure, generate `AGENTS.md`, compile existing raw notes |
| `/wiki-compile` | Compiler | Extract concepts from new raw notes, enforce independence tests, build cross-references |
| `/wiki-topic` | Analyst | Question-driven synthesis — LLM reveals causal chains, tensions, analogies, hypotheses |
| `/wiki-lint` | Inspector | Monthly health check: broken links, orphans, fragile dependencies, concept evolution |

## The Mechanisms That Make It Work

### Concept Independence Test
Every new concept must earn its page. Before creating a wiki entry, the LLM checks:
- **Definability** — can it be clearly stated in 1-2 sentences without circular jargon?
- **Single core** — is this one concept, or "A and B" glued together? Compound concepts are split.
- **Multi-source** — does it appear in at least two different source notes with independent perspectives?

This prevents the two diseases of knowledge bases: overgeneralized tags ("Technology", "Society") and one-off specifics that should have stayed in the raw layer.

### Concept Evolution (Never Overwrite)
New information appends by default. Core definitions change only when new evidence **explicitly corrects** an old factual error — and when that happens, the old understanding is archived with a timestamp. Conflicts are recorded side-by-side in a "Different Perspectives" section. Your intellectual history is preserved, not erased.

### Cross-Reference Integrity
Every claim links to its raw source. Every wiki link is bidirectional. `linked_count` is verified on each compile. Broken links are surfaced in the health report. There is no hidden state — everything is plain Markdown with YAML frontmatter.

## Design Principles

- **Connect the dots** — fragmented information → organized network → personal opinions
- **Human judges, LLM compiles** — you handle creativity, judgment, and questions; the LLM handles compilation, linking, and health checks
- **Occam's Razor** — no complexity beyond folders + Markdown + Obsidian native features
- **Compound interest** — knowledge compiled once, appreciated continuously

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) or compatible AI agent
- [Obsidian](https://obsidian.md/) (recommended — graph view makes the concept network visible)

## License

MIT. Free forever. Go build your knowledge.

---

*Inspired by [Karpathy's llm-wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) concept.*
