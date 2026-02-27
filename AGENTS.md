# Mood Tracker - Proyecto de Desarrollo Guiado por IA

## Descripcion

Prototipo rapido de una aplicacion de seguimiento de estados de animo (Mood Tracker). Monorepo con dos subproyectos independientes: un backend API REST y un frontend SPA.

## Estructura del Proyecto

```
/
├── backend/          # API REST con NestJS 11
│   ├── src/
│   │   ├── main.ts              # Bootstrap, CORS habilitado, puerto 3000
│   │   ├── app.module.ts        # Modulo raiz, importa MoodsModule
│   │   └── moods/
│   │       ├── moods.module.ts
│   │       ├── moods.controller.ts   # POST /add, GET /list
│   │       ├── moods.service.ts      # Logica de negocio, almacenamiento en memoria
│   │       └── dto/
│   │           ├── create-mood.dto.ts
│   │           ├── mood-entry.dto.ts
│   │           ├── add-mood-response.dto.ts
│   │           └── list-moods-response.dto.ts
│   ├── package.json
│   ├── tsconfig.json
│   └── Makefile
│
├── frontend/         # SPA con Angular 21
│   ├── src/
│   │   ├── main.ts              # Bootstrap standalone con HttpClient
│   │   ├── index.html
│   │   └── app/
│   │       └── app.component.ts # Componente unico, template y estilos inline
│   ├── package.json
│   ├── angular.json
│   └── tsconfig.json
│
├── opencode.json     # Configuracion de OpenCode
└── AGENTS.md         # Este archivo
```

## Tecnologias y Versiones

| Componente | Backend | Frontend |
|------------|---------|----------|
| Framework  | NestJS 11 | Angular 21.1.2 |
| TypeScript | 5.7 | 5.9.3 |
| Node.js    | v24.11.1 | v24.11.1 |
| Puerto     | 3000 | 4200 |

## Comandos de Arranque

- **Backend**: `cd backend && make dev` o `cd backend && npm run start:dev`
- **Frontend**: `cd frontend && npm start` (ejecuta `ng serve`)

## Endpoints del API

- `POST /add` - Crear una nueva entrada de estado de animo (body: `CreateMoodDto`)
- `GET /list` - Listar todos los estados de animo ordenados por timestamp descendente

## Convenciones de Codigo

### Backend (NestJS)

- TypeScript con `strict: true`
- Patron modular de NestJS: Module -> Controller -> Service
- DTOs tipados para request/response (`CreateMoodDto`, `MoodEntry`, `AddMoodResponse`, `ListMoodsResponse`)
- Almacenamiento en memoria (array simple, sin base de datos)
- CORS habilitado con origenes wildcard

### Frontend (Angular)

- Componentes standalone (sin NgModules)
- Template y estilos inline en el componente
- HttpClient para comunicacion con el backend
- Strict mode deshabilitado en tsconfig

### General

- Los dos subproyectos son independientes (no hay workspace root de npm/yarn/pnpm)
- Cada subproyecto tiene su propio `node_modules/` y `package-lock.json`
- Node.js v24.11.1 especificado en `.nvmrc` de cada subproyecto
- No hay linting, testing ni CI/CD configurado aun

## Notas Importantes

- Este es un proyecto kata/prototipo. El codigo frontend es deliberadamente simple.
- No hay validacion con class-validator en el backend.
- No hay tests unitarios ni de integracion.
- No hay configuracion de linting (ESLint) ni formatting (Prettier) a nivel de proyecto.
