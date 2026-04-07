# Backend — NestJS

API REST construida con NestJS. Almacenamiento en memoria (datos se pierden al reiniciar).

## Endpoints

| Método | Ruta | Body | Respuesta |
|--------|------|------|-----------|
| POST | `/add` | `{ mood?: string, note?: string }` | `{ status: string, entry: MoodEntry }` |
| GET | `/list` | — | `{ moods: MoodEntryWithAge[], count: number }` |

## Arquitectura

```
src/
  main.ts                 # Bootstrap, CORS habilitado para *, puerto 3000
  app.module.ts           # Módulo raíz, importa MoodsModule
  moods/
    moods.module.ts
    moods.controller.ts   # Rutas: POST /add, GET /list
    moods.service.ts      # Lógica de negocio, almacenamiento en db[]
    dto/
      create-mood.dto.ts          # { mood?: string, note?: string }
      mood-entry.dto.ts           # MoodEntry, MoodEntryWithAge
      add-mood-response.dto.ts    # { status, entry }
      list-moods-response.dto.ts  # { moods, count }
```

## Reglas

✓ Usar DTOs tipados en `dto/` para todo input y output de endpoints.
✗ No aceptar `@Body() data: any` — siempre usar DTOs con class-validator.

✓ La lógica de negocio va en el servicio, nunca en el controlador.
✗ No acceder a `this.db` directamente desde el controlador.

✓ Añadir tests unitarios para cada método público del servicio.

## Comandos

```bash
npm run start:dev   # Desarrollo con hot reload
npm run build       # Compilar a dist/
npm test            # Ejecutar tests
npm run lint        # Linter
```
