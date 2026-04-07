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
```

## Setup

```bash
# Backend
cd backend && npm install && npm run start:dev

# Frontend
cd frontend && npm install && npm start
```

## Reglas

✓ Usar interfaces TypeScript tipadas para todos los datos.
✗ Nunca usar `any` en código TypeScript.

✓ Los estilos CSS van en ficheros `.css` separados.
✗ No usar estilos inline en templates de Angular ni en componentes.

✓ Seguir el formato de commits convencionales: `feat:`, `fix:`, `chore:`, `test:`.

## Referencias

- Contexto del backend: `backend/AGENTS.md`
- Contexto del frontend: `frontend/AGENTS.md`
