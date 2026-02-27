---
description: Muestra el estado completo de ambos subproyectos
---

Muestra un resumen del estado actual del proyecto Mood Tracker.

## Estado de Git
!`git status --short 2>&1`

!`git log --oneline -5 2>&1`

## Dependencias Backend
!`cd backend && node -e "const p=require('./package.json'); console.log(p.name + '@' + p.version)" 2>&1`

## Dependencias Frontend
!`cd frontend && node -e "const p=require('./package.json'); console.log(p.name + '@' + p.version)" 2>&1`

## Version de Node
!`node --version 2>&1`

Resume el estado general del proyecto incluyendo:
- Estado del repositorio git (branch actual, cambios pendientes)
- Ultimos commits
- Versiones de los subproyectos
- Version de Node.js activa
