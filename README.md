# Mood Tracker

Un prototipo de seguimiento de estados de ánimo construido con un backend en NestJS y un frontend en Angular.

## Requisitos previos

- **Node.js** v24.11.1 (especificado en `.nvmrc` de cada proyecto)
- **npm** (incluido con Node.js)
- **nvm** (opcional, para gestionar versiones de Node.js)

Con nvm:
```bash
nvm install 24.11.1
nvm use 24.11.1
```

## Estructura del proyecto

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
│   └── tsconfig.json
├── frontend/          # Aplicación Angular
│   ├── src/
│   │   └── app/
│   │       └── app.component.ts       # Componente único standalone
│   ├── package.json
│   └── angular.json
└── README.md
```

## Inicio rápido

Abre dos terminales. En la primera, levanta el backend; en la segunda, el frontend.

**Terminal 1 — Backend:**
```bash
cd backend
npm install
npm run start:dev
```

**Terminal 2 — Frontend:**
```bash
cd frontend
npm install
npm start
```

- Backend: `http://localhost:3000`
- Frontend: `http://localhost:4200`

---

## Backend

**Tecnologías:** NestJS 11 · TypeScript 5.7 · Node.js v24

### Instalación

```bash
cd backend
npm install
```

### Comandos

| Comando | Descripción |
|---|---|
| `npm run start:dev` | Servidor de desarrollo con hot reload (recomendado) |
| `npm start` | Servidor de producción |
| `npm run build` | Compilar TypeScript a `dist/` |

El servidor escucha en **`http://localhost:3000`**.

### Arquitectura

```
src/
  main.ts              # Bootstrap, habilita CORS para todos los orígenes, puerto 3000
  app.module.ts        # Módulo raíz, importa MoodsModule
  moods/
    moods.module.ts
    moods.controller.ts   # Rutas POST /add y GET /list
    moods.service.ts      # Lógica de negocio y almacenamiento en memoria
    dto/
      create-mood.dto.ts        # { mood?: string, note?: string }
      mood-entry.dto.ts         # MoodEntry y MoodEntryWithAge
      add-mood-response.dto.ts
      list-moods-response.dto.ts
```

### Notas

- **Almacenamiento en memoria:** los datos se pierden al reiniciar el servidor (sin base de datos).
- **CORS:** habilitado para todos los orígenes (`*`), todos los métodos y cabeceras.

---

## Frontend

**Tecnologías:** Angular 21 · TypeScript 5.9 · Node.js v24

### Instalación

```bash
cd frontend
npm install
```

### Comandos

| Comando | Descripción |
|---|---|
| `npm start` | Servidor de desarrollo |
| `npm run build` | Build de producción en `dist/` |
| `npm run watch` | Build en modo watch (desarrollo) |

La aplicación estará disponible en **`http://localhost:4200`**.

---

## Problemas conocidos

- **Mismatch de puertos en el frontend:** `app.component.ts` apunta a `http://localhost:8000` pero el backend escucha en el puerto `3000`. Para que el frontend se comunique correctamente con el backend, es necesario corregir la URL en `frontend/src/app/app.component.ts`:
  ```typescript
  private apiUrl = 'http://localhost:3000'; // corregir desde 8000
  ```
