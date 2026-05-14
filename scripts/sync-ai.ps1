# sync-ai.ps1 — Genera agentes por herramienta y sincroniza .ai/.
# Crea junctions de directorio (no requiere permisos de administrador).
# En Unix/macOS usa scripts/sync-ai.sh en su lugar.
#
# Uso:
#   powershell -ExecutionPolicy Bypass -File scripts/sync-ai.ps1 -Platform claude -DryRun

param(
  [ValidateSet("all", "claude", "codex", "opencode", "cursor")]
  [string]$Platform = "all",
  [switch]$DryRun
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir   = Split-Path -Parent $ScriptDir
$AiDir     = Join-Path $RootDir ".ai"

function Platform-Enabled {
  param([string]$Name)
  return $Platform -eq "all" -or $Platform -eq $Name
}

function Link-Dir {
  param([string]$Src, [string]$Dst)

  if (-not (Test-Path $Src)) { return }

  # Eliminar destino previo
  if (Test-Path $Dst) {
    Remove-Item -Recurse -Force $Dst
  }

  $Parent = Split-Path -Parent $Dst
  if (-not (Test-Path $Parent)) {
    New-Item -ItemType Directory -Force $Parent | Out-Null
  }

  New-Item -ItemType Junction -Path $Dst -Target $Src | Out-Null
  Write-Host "  linked  $Dst -> $Src"
}

function Sync-Dir {
  param([string]$PlatformName, [string]$Src, [string]$Dst)

  if (-not (Platform-Enabled $PlatformName)) { return }

  if ($DryRun) {
    Write-Host "  would link  $Dst -> $Src"
    return
  }

  Link-Dir $Src $Dst
}

Write-Host "Syncing .ai/ -> agent folders..."

if ($DryRun) {
  & (Join-Path $RootDir "scripts/generate-agents") --platform $Platform --dry-run
} else {
  & (Join-Path $RootDir "scripts/generate-agents") --platform $Platform
}

# Claude Code
Sync-Dir "claude" (Join-Path $AiDir "commands") (Join-Path $RootDir ".claude\commands")
Sync-Dir "claude" (Join-Path $AiDir "skills") (Join-Path $RootDir ".claude\skills")
Sync-Dir "claude" (Join-Path $AiDir "generated\claude\agents") (Join-Path $RootDir ".claude\agents")

# Cursor
Sync-Dir "cursor" (Join-Path $AiDir "commands") (Join-Path $RootDir ".cursor\commands")
Sync-Dir "cursor" (Join-Path $AiDir "skills") (Join-Path $RootDir ".cursor\skills")
Sync-Dir "cursor" (Join-Path $AiDir "generated\cursor\agents") (Join-Path $RootDir ".cursor\agents")

# OpenCode
Sync-Dir "opencode" (Join-Path $AiDir "commands") (Join-Path $RootDir ".opencode\commands")
Sync-Dir "opencode" (Join-Path $AiDir "skills") (Join-Path $RootDir ".opencode\skills")
Sync-Dir "opencode" (Join-Path $AiDir "generated\opencode\agents") (Join-Path $RootDir ".opencode\agents")

# Codex
Sync-Dir "codex" (Join-Path $AiDir "generated\codex\agents") (Join-Path $RootDir ".codex\agents")

Write-Host "Done."
