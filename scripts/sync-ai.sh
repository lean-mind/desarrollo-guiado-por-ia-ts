#!/usr/bin/env bash
# sync-ai.sh — Sincroniza .ai/ a las carpetas específicas de cada agente.
#
# En Unix/macOS crea symlinks (los cambios en .ai/ se reflejan automáticamente).
# En Windows o si prefieres copias, pasa --copy como argumento.
#
# Uso:
#   ./scripts/sync-ai.sh          # symlinks (por defecto)
#   ./scripts/sync-ai.sh --copy   # copias

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AI_DIR="$ROOT_DIR/.ai"

USE_COPY=false
[[ "${1:-}" == "--copy" ]] && USE_COPY=true

link_or_copy() {
  local src="$1"
  local dst="$2"

  [[ -e "$src" ]] || return 0

  # Eliminar destino previo (symlink, directorio o fichero)
  [[ -e "$dst" || -L "$dst" ]] && rm -rf "$dst"
  mkdir -p "$(dirname "$dst")"

  if [[ "$USE_COPY" == true ]]; then
    cp -r "$src" "$dst"
    echo "  copied  $dst"
  else
    ln -s "$src" "$dst"
    echo "  linked  $dst → $src"
  fi
}

echo "Syncing .ai/ → agent folders..."

# Claude Code
link_or_copy "$AI_DIR/commands" "$ROOT_DIR/.claude/commands"
link_or_copy "$AI_DIR/skills"   "$ROOT_DIR/.claude/skills"
link_or_copy "$AI_DIR/agents"   "$ROOT_DIR/.claude/agents"

# Cursor
link_or_copy "$AI_DIR/commands" "$ROOT_DIR/.cursor/commands"
link_or_copy "$AI_DIR/skills"   "$ROOT_DIR/.cursor/skills"
link_or_copy "$AI_DIR/agents"   "$ROOT_DIR/.cursor/agents"

# OpenCode
link_or_copy "$AI_DIR/commands" "$ROOT_DIR/.opencode/commands"
link_or_copy "$AI_DIR/skills"   "$ROOT_DIR/.opencode/skills"
link_or_copy "$AI_DIR/agents"   "$ROOT_DIR/.opencode/agents"

echo "Done."
