---
description: Ejecuta linting y formatting en todo el proyecto
---

Ejecuta las herramientas de linting y formatting disponibles en el proyecto.

## Verificar TypeScript (Backend)
!`cd backend && npx tsc --noEmit 2>&1 || true`

## Verificar TypeScript (Frontend)
!`cd frontend && npx tsc --noEmit 2>&1 || true`

Analiza los resultados:
- Si hay errores de TypeScript, lista cada uno con archivo, linea y descripcion
- Corrige los errores que puedas resolver automaticamente
- Para errores que requieran decision del desarrollador, presenta las opciones

Si se pasa un archivo o patron como argumento, enfocate solo en ese: $ARGUMENTS
