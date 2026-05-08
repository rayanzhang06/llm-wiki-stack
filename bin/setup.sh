#!/usr/bin/env bash
set -e

# Resolve the real package root, even when invoked via npx symlink chain.
# npx creates .bin/<cmd> -> ../<pkg>/bin/setup.sh, so $0 is the symlink.
resolve_script() {
  local target="$1"
  local max_depth=10
  while [ -L "$target" ] && [ "$max_depth" -gt 0 ]; do
    local link
    link="$(readlink "$target")"
    case "$link" in
      /*) target="$link" ;;
      *)  target="$(cd "$(dirname "$target")" && pwd)/$link" ;;
    esac
    max_depth=$((max_depth - 1))
  done
  echo "$target"
}

SCRIPT="$(resolve_script "$0")"
PKG_ROOT="$(cd "$(dirname "$SCRIPT")/.." && pwd)"
SKILLS_SRC="$PKG_ROOT/skills"
SKILLS_DST="${HOME}/.claude/skills"

echo "llm-wiki-stack installer"
echo "========================"
echo ""

# Install each skill into ~/.claude/skills/
for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name=$(basename "$skill_dir")
  target="$SKILLS_DST/$skill_name"

  if [ -d "$target" ]; then
    echo "  updating: $skill_name (existing install, backing up)"
    rm -rf "${target}.bak" 2>/dev/null
    mv "$target" "${target}.bak"
  else
    echo "  installing: $skill_name"
  fi

  mkdir -p "$SKILLS_DST"
  cp -R "$skill_dir" "$target"
done

echo ""
echo "Done. Available commands:"
echo "  /kb-init         — bootstrap a new knowledge base"
echo "  /wiki-compile    — compile raw sources into wiki"
echo "  /wiki-topic      — question-driven topic synthesis"
echo "  /wiki-lint       — health check and structured report"
echo ""
echo "Each command delegates to llm-wiki-stack, which reads"
echo "your repo-local AGENTS.md as the schema of truth."
