# Mood Tracker

Un prototipo rápido de seguimiento de estados de ánimo (Mood Tracker) construido con un monorepo que contiene un backend en TypeScript con NestJS y un frontend en Angular.

## Estructura del Proyecto

```
.
├── backend/           # API NestJS (TypeScript)
│   ├── src/
│   │   ├── main.ts                    # Bootstrap + CORS (puerto 3000)
│   │   ├── app.module.ts
│   │   └── moods/
│   │       ├── moods.module.ts
│   │       ├── moods.controller.ts    # POST /add, GET /list
│   │       ├── moods.service.ts       # Lógica + almacenamiento en memoria
│   │       └── dto/                   # Interfaces y DTOs
│   ├── package.json
│   ├── tsconfig.json
│   └── Makefile
├── frontend/          # Aplicación Angular
│   ├── src/
│   └── package.json
└── README.md
```

## Backend

Tecnologías: NestJS 11 + TypeScript 5.7 + Node.js v24

### Instalar dependencias

```bash
cd backend
npm install
```

### Levantar el servidor

```bash
cd backend
make dev
```

El servidor correrá en `http://localhost:3000`

### Endpoints

- `POST /add` — Agregar un nuevo mood. Body: `{ "mood"?: string, "note"?: string }`
- `GET /list` — Listar todos los moods ordenados por timestamp descendente

#### Ejemplo

```bash
curl -X POST http://localhost:3000/add \
  -H 'Content-Type: application/json' \
  -d '{"mood": "happy", "note": "buen día"}'

curl http://localhost:3000/list
```

## Frontend

Tecnologías: Angular 21 + TypeScript 5.8 + npm

### Instalar dependencias

```bash
cd frontend
npm install
```

### Levantar la aplicación

```bash
cd frontend
npm start
```

La aplicación correrá en `http://localhost:4200`

## Características

- Backend con almacenamiento en memoria (sin base de datos)
- CORS habilitado para comunicación entre puertos
- Frontend con diseño colorido y estilos inline
