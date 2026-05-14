#!/usr/bin/env bash
# sync-ai.sh — Genera agentes por herramienta y sincroniza .ai/.
# Crea symlinks (los cambios en .ai/ se reflejan automáticamente).
# En Windows usa scripts/sync-ai.ps1 en su lugar.
#
# Uso:
#   ./scripts/sync-ai.sh [--platform claude|codex|opencode|cursor|all] [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AI_DIR="$ROOT_DIR/.ai"
PLATFORM="all"
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform|--plaform)
      PLATFORM="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

platform_enabled() {
  [[ "$PLATFORM" == "all" || "$PLATFORM" == "$1" ]]
}

link_or_copy() {
  local src="$1"
  local dst="$2"

  [[ -e "$src" ]] || return 0

  # Eliminar destino previo (symlink, directorio o fichero)
  [[ -e "$dst" || -L "$dst" ]] && rm -rf "$dst"
  mkdir -p "$(dirname "$dst")"

  ln -s "$src" "$dst"
  echo "  linked  $dst → $src"
}

sync_dir() {
  local platform="$1"
  local src="$2"
  local dst="$3"

  platform_enabled "$platform" || return 0

  if [[ "$DRY_RUN" == true ]]; then
    echo "  would link  $dst → $src"
    return 0
  fi

  link_or_copy "$src" "$dst"
}

echo "Syncing .ai/ → agent folders..."

if [[ "$DRY_RUN" == true ]]; then
  "$ROOT_DIR/scripts/generate-agents" --platform "$PLATFORM" --dry-run
else
  "$ROOT_DIR/scripts/generate-agents" --platform "$PLATFORM"
fi

# Claude Code
sync_dir claude "$AI_DIR/commands" "$ROOT_DIR/.claude/commands"
sync_dir claude "$AI_DIR/skills" "$ROOT_DIR/.claude/skills"
sync_dir claude "$AI_DIR/generated/claude/agents" "$ROOT_DIR/.claude/agents"

# Cursor
sync_dir cursor "$AI_DIR/commands" "$ROOT_DIR/.cursor/commands"
sync_dir cursor "$AI_DIR/skills" "$ROOT_DIR/.cursor/skills"
sync_dir cursor "$AI_DIR/generated/cursor/agents" "$ROOT_DIR/.cursor/agents"

# OpenCode
sync_dir opencode "$AI_DIR/commands" "$ROOT_DIR/.opencode/commands"
sync_dir opencode "$AI_DIR/skills" "$ROOT_DIR/.opencode/skills"
sync_dir opencode "$AI_DIR/generated/opencode/agents" "$ROOT_DIR/.opencode/agents"

# Codex
sync_dir codex "$AI_DIR/generated/codex/agents" "$ROOT_DIR/.codex/agents"

# MCP — configuración canónica en .ai/mcp.json
sync_dir claude "$AI_DIR/mcp.json" "$ROOT_DIR/.mcp.json"
sync_dir cursor "$AI_DIR/mcp.json" "$ROOT_DIR/.cursor/mcp.json"

# Git hooks (compatible con submódulos: .git puede ser un gitfile)
if [[ "$DRY_RUN" == false && -d "$AI_DIR/hooks" ]]; then
  git_hooks_dir="$(cd "$ROOT_DIR" && git rev-parse --git-dir)/hooks"
  mkdir -p "$git_hooks_dir"
  for hook_file in "$AI_DIR/hooks"/*; do
    [ -f "$hook_file" ] || continue
    hook_name="$(basename "$hook_file")"
    dst="$git_hooks_dir/$hook_name"
    ln -sf "$hook_file" "$dst"
    chmod +x "$dst"
    echo "  hook    $hook_name"
  done
fi

echo "Done."
