# sync-ai.ps1 — Sincroniza .ai/ a las carpetas específicas de cada agente.
# Crea junctions de directorio (no requiere permisos de administrador).
# En Unix/macOS usa scripts/sync-ai.sh en su lugar.
#
# Uso:
#   powershell -ExecutionPolicy Bypass -File scripts/sync-ai.ps1

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir   = Split-Path -Parent $ScriptDir
$AiDir     = Join-Path $RootDir ".ai"

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

Write-Host "Syncing .ai/ -> agent folders..."

# Claude Code
Link-Dir (Join-Path $AiDir "commands") (Join-Path $RootDir ".claude\commands")
Link-Dir (Join-Path $AiDir "skills")   (Join-Path $RootDir ".claude\skills")
Link-Dir (Join-Path $AiDir "agents")   (Join-Path $RootDir ".claude\agents")

# Cursor
Link-Dir (Join-Path $AiDir "commands") (Join-Path $RootDir ".cursor\commands")
Link-Dir (Join-Path $AiDir "skills")   (Join-Path $RootDir ".cursor\skills")
Link-Dir (Join-Path $AiDir "agents")   (Join-Path $RootDir ".cursor\agents")

# OpenCode
Link-Dir (Join-Path $AiDir "commands") (Join-Path $RootDir ".opencode\commands")
Link-Dir (Join-Path $AiDir "skills")   (Join-Path $RootDir ".opencode\skills")
Link-Dir (Join-Path $AiDir "agents")   (Join-Path $RootDir ".opencode\agents")

Write-Host "Done."
