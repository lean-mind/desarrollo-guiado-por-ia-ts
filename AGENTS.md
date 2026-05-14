# Mood Tracker — TypeScript

Aplicación de seguimiento de estados de ánimo. Monorepo con backend en NestJS y frontend en Angular.

## Stack

| Capa | Tecnología | Versión |
|------|-----------|---------|
| Backend | NestJS | 11 |
| Backend | TypeScript | 5.7 |
| Backend | Node.js | v24 |
| Frontend | Angular | 21 |
| Frontend | TypeScript | 5.9 |
| Frontend | Node.js | v24 |

## Estructura

```
backend/    # API NestJS (puerto 3000)
frontend/   # Aplicación Angular (puerto 4200)
docs/       # Reglas y convenciones globales del proyecto
```

## Setup

```bash
# Backend
cd backend && npm install && npm run start:dev

# Frontend
cd frontend && npm install && npm start
```

## Agentes especializados

Los agentes se definen primero como manifiestos agnósticos en `.ai/agents/*.yaml` y prompts compartidos en `.ai/agents/prompts/`. Después `scripts/generate-agents` genera los adaptadores de Claude, Codex, OpenCode y Cursor en `.ai/generated/`.

`.ai/agents/debater.yaml` — analiza el problema con preguntas socráticas y genera un PRD.
`.ai/agents/planner.yaml` — lee el PRD y elabora el plan de implementación como checklist.
`.ai/agents/executor.yaml` — implementa el plan paso a paso con TDD, marcando items y commiteando.
`.ai/agents/reviewer.yaml` — revisa la implementación contra el plan y las reglas.

## Skills

`.ai/skills/tdd/` — ciclo Red-Green-Refactor para implementar con tests primero.
`.ai/skills/commit/` — convenciones de Conventional Commits.

## Reglas globales

Ver `docs/commits.md` para convenciones de commits.
