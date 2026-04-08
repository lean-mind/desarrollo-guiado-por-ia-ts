#!/usr/bin/env bash
# sync-ai.sh — Sincroniza .ai/ a las carpetas específicas de cada agente.
# Crea symlinks (los cambios en .ai/ se reflejan automáticamente).
# En Windows usa scripts/sync-ai.ps1 en su lugar.
#
# Uso:
#   ./scripts/sync-ai.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AI_DIR="$ROOT_DIR/.ai"

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

# Git hooks (compatible con submódulos: .git puede ser un gitfile)
if [ -d "$AI_DIR/hooks" ]; then
  git_hooks_dir="$(cd "$ROOT_DIR" && git rev-parse --git-dir)/hooks"
  mkdir -p "$git_hooks_dir"
  for hook_file in "$AI_DIR/hooks"/*; do
    [ -f "$hook_file" ] || continue
    hook_name="$(basename "$hook_file")"
    dst="$git_hooks_dir/$hook_name"
    if [[ "$USE_COPY" == true ]]; then
      cp "$hook_file" "$dst"
    else
      ln -sf "$hook_file" "$dst"
    fi
    chmod +x "$dst"
    echo "  hook    $hook_name"
  done
fi

echo "Done."
