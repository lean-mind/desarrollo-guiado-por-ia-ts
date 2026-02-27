---
description: Construye ambos subproyectos (backend y frontend) y reporta errores
agent: fullstack-refactor
---

Construye ambos subproyectos en secuencia y reporta el resultado.

## Backend
!`cd backend && npm run build 2>&1 || true`

## Frontend
!`cd frontend && npm run build 2>&1 || true`

Analiza los resultados de ambos builds:
- Si ambos compilan correctamente, confirma con un resumen
- Si hay errores de compilacion, lista cada error con archivo, linea y descripcion
- Sugiere correcciones concretas para cada error encontrado
