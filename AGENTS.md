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

## Skills

`.ai/skills/tdd/` — ciclo Red-Green-Refactor para implementar con tests primero.
`.ai/skills/commit/` — convenciones de Conventional Commits.

## Reglas globales

Ver `docs/commits.md` para convenciones de commits.
