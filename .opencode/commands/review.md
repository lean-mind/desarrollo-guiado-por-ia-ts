---
description: Hace code review de los cambios actuales usando git diff
agent: code-reviewer
subtask: true
---

Revisa los cambios pendientes del repositorio.

## Cambios actuales
!`git diff --stat 2>&1`

!`git diff 2>&1`

## Cambios staged
!`git diff --cached --stat 2>&1`

!`git diff --cached 2>&1`

Realiza un code review de todos los cambios mostrados arriba. Para cada hallazgo reporta:
1. Archivo y linea
2. Severidad (critico, alto, medio, bajo)
3. Descripcion del problema
4. Sugerencia concreta de mejora

Si se proporcionan instrucciones adicionales, tenlas en cuenta: $ARGUMENTS
