# Ejercicio 4 — Feedback rápido

## De qué va

Hasta ahora el agente podía escribir código sin que nada lo frenara automáticamente. Este ejercicio aplica los conceptos de M3.1 (entorno de feedback rápido): montar el tooling que convierte cada commit en una prueba de calidad. El linter, el tipado estricto y el hook pre-commit ya están configurados — tu trabajo es experimentar cómo cambia la dinámica del agente cuando existe ese feedback.

## Punto de partida

Estáis en la rama `ejercicio-4`, que parte de `solucion-3`. Todo el tooling de feedback está precocinado y activo desde el primer commit.

### Ya hecho en esta rama (ejemplos)

- `backend/eslint.config.mjs` — reglas ESLint para el backend NestJS.
- `frontend/eslint.config.mjs` — reglas ESLint para el frontend Angular.
- `frontend/tsconfig.json` — TypeScript en modo estricto (`strict: true`).
- `.ai/hooks/pre-commit` — hook que ejecuta typecheck + lint + tests antes de cada commit.
- `scripts/sync-ai.sh` — actualizado para enlazar el hook a `.git/hooks/pre-commit`.

Antes de empezar, ejecutad `bash scripts/sync-ai.sh` para activar el hook localmente.

## Vuestra tarea (obligatoria)

Usar el ciclo `/plan → /execute` para añadir un campo `createdAt` a los moods: se asigna automáticamente al crearlo, se devuelve en las respuestas y hay tests que lo cubren.

Observad cómo el hook pre-commit interactúa con el agente: `/execute` commitea tras cada check del plan, y el hook se dispara en cada uno de ellos.

**Hecho cuando:**
- [ ] Existe un plan en `.ai/workspace/plans/` con varios checks atómicos.
- [ ] Al ejecutar `/execute`, el agente commitea al completar cada check.
- [ ] El historial de commits muestra evidencia de que el hook se ejecutó (correcciones de linter o tipos antes de avanzar al siguiente check).
- [ ] La feature `createdAt` funciona end-to-end con tests verdes y `npm test` pasa sin errores.

## Extra (si acabáis antes)

Añadir una regla nueva al linter o al hook (p.ej., que falle si hay un `console.log` en el código de producción) y volver a ejecutar el ciclo para ver cómo cambia la dinámica del agente.

**Hecho cuando:**
- [ ] La nueva regla está configurada en `eslint.config.mjs` o en `.ai/hooks/pre-commit`.
- [ ] Al ejecutar `/execute` con la nueva regla activa, el agente se adapta sin intervención manual.

## Pistas / preguntas mientras trabajáis

- ¿En qué commits falló el hook? ¿Fue por linter, por tipos o por tests?
- ¿El agente corrigió el error solo o necesitó que le dijérais qué había fallado?
- ¿Habría cometido ese error sin el hook? ¿Cómo lo sabrías?
- ¿Qué reglas añadiríais al linter y cuáles dejaríais fuera para no ralentizar el commit?
- Si el hook tarda más de 10 segundos, ¿qué haríais?

## Referencia

Cuando terminéis, comparad con la rama `solucion-4`:

```bash
git diff ejercicio-4..solucion-4 -- backend/ frontend/
```
