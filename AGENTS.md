# AGENTS.md — Monorepo Root

This repository contains two independent sub-projects that together form the Mood Tracker application:

| Layer | Directory | Stack |
|---|---|---|
| REST API | `backend/` | NestJS 11, Node.js v24, TypeScript (strict) |
| SPA | `frontend/` | Angular 21, TypeScript (non-strict) |

For layer-specific details load the relevant child guide:
- **`backend/AGENTS.md`** — NestJS commands, patterns, DI, module structure
- **`backend/src/moods/AGENTS.md`** — moods feature: DTOs, service, controller
- **`frontend/AGENTS.md`** — Angular commands, component model, HTTP client

---

## Interoperability

### Runtime Addresses

| Service | Default port | Notes |
|---|---|---|
| Backend | `3000` | NestJS default (`backend/src/main.ts:11`) |
| Frontend dev server | `4200` | Angular CLI default |
| Frontend `apiUrl` | **`8000`** | **Known inconsistency** — hardcoded in `frontend/src/app/app.component.ts:57` |

To run both together locally change `apiUrl` to `http://localhost:3000`, or proxy the Angular dev server to port 3000.

### CORS

CORS is fully open in `backend/src/main.ts:6-10`:
```typescript
app.enableCors({ origin: '*', methods: '*', allowedHeaders: '*' });
```
No credentials, cookies, or auth headers are in use. Do not tighten CORS without also updating the frontend.

### Authentication

**No authentication is implemented.** All endpoints are public. If you add auth:
1. Add a Guard on the backend (`@UseGuards()`).
2. Store and send the token from `AppComponent` via an `Authorization` header.
3. Update CORS to allow the `Authorization` header (remove the wildcard allowedHeaders first).

---

## API Contract

All HTTP communication is plain JSON with no versioning prefix. The base path is `/`.

### Endpoints

| Method | Path | Request body | Success response |
|---|---|---|---|
| `POST` | `/add` | `{ mood?: string, note?: string }` | `{ status: "added", entry: MoodEntry }` |
| `GET` | `/list` | — | `{ moods: MoodEntryWithAge[], count: number }` |

### Shared Shape — `MoodEntry`

Both layers implicitly agree on this structure. The backend defines it in
`backend/src/moods/dto/mood-entry.dto.ts`; the frontend consumes it as `any`.

```typescript
interface MoodEntry {
  id: number;
  mood: string;
  note: string;
  timestamp: string;        // "YYYY-MM-DDTHH:mm:ss.ffffff"
  date_formatted: string;   // "YYYY-MM-DD HH:mm:ss"
  day_of_week: string;      // "Monday" … "Sunday"
  is_weekend: boolean;
}

interface MoodEntryWithAge extends MoodEntry {
  age_in_seconds: number;   // only in /list responses
}
```

**If you change any field name or type in the backend DTOs you must update the frontend template and component class.** The frontend currently reads `item.mood`, `item.note`, `item.date_formatted`, `item.day_of_week` directly in the template (`frontend/src/app/app.component.ts:46-48`).

### Request Validation

The backend uses **no validation library** (`class-validator` is not installed). Fields are optional; the service falls back to `'unknown'` for `mood` and `''` for `note`. Do not add `@IsString()` / `@IsNotEmpty()` decorators without first installing `class-validator` and `class-transformer` and enabling the `ValidationPipe`.

---

## Error Handling Contract

| Scenario | Backend behaviour | Frontend behaviour |
|---|---|---|
| Unknown route | NestJS default 404 JSON | Not handled — `error` callback fires |
| Validation error (future) | `BadRequestException` → 400 JSON | Should display user-visible message |
| Server crash | 500 JSON (NestJS default) | `alert('ERROR AL GUARDAR!')` for POST; empty list for GET |

Errors from the backend arrive as JSON:
```json
{ "statusCode": 404, "message": "Cannot GET /foo", "error": "Not Found" }
```

The frontend does not parse `statusCode` or `message` today — it only logs and alerts.

---

## Shared Conventions

- **No shared package** — DTOs are not shared via a library. Types must be kept in sync manually.
- **No environment variables** — no `.env` files, no config module. Connection details are hardcoded.
- **No CI/CD** — no GitHub Actions, no Docker.
- **Node version** — both sub-projects target **v24.11.1** (`.nvmrc` in each directory).
- **No database** — data lives in memory; restarting the backend clears all moods.

---

## Programming Principles

These principles apply across the entire monorepo. All contributions must respect them.

### SOLID

| Principio | Descripción | Violación actual |
|---|---|---|
| **S** — Single Responsibility | Cada clase/función tiene una única razón de cambiar | `MoodsService` construye entidades, valida y almacena datos |
| **O** — Open/Closed | Abierto a extensión, cerrado a modificación | Agregar un nuevo tipo de almacenamiento requiere modificar `MoodsService` |
| **L** — Liskov Substitution | Las subclases deben poder sustituir a sus clases base sin romper el comportamiento | No aplica aún — no hay jerarquías de clases |
| **I** — Interface Segregation | Las interfaces deben ser específicas; no forzar dependencias innecesarias | No hay interfaces definidas explícitamente |
| **D** — Dependency Inversion | Depender de abstracciones, no de implementaciones concretas | `MoodsController` depende directamente de `MoodsService` (concreto) |

### DRY — Don't Repeat Yourself

Cada pieza de conocimiento debe tener una única representación en el sistema.

- **Violación actual:** el contrato `MoodEntry` está duplicado — definido en `backend/src/moods/dto/mood-entry.dto.ts` y replicado implícitamente en el template del frontend como `item.mood`, `item.note`, etc.
- **Regla:** si cambias un campo en el backend, debes actualizar el frontend en la misma operación.

### YAGNI — You Aren't Gonna Need It

No implementar funcionalidad hasta que sea necesaria.

- No añadir autenticación, base de datos, o paginación hasta que el producto lo requiera.
- No crear abstracciones genéricas para casos de uso que hoy son únicos.

### KISS — Keep It Simple, Stupid

Preferir la solución más simple que resuelva el problema.

- Antes de introducir un patrón (Repository, Factory, etc.), verificar que la complejidad actual lo justifica.
- El código existente es intencionalmente simple. Aumentar la complejidad estructural debe tener una razón concreta (testabilidad, intercambiabilidad, reutilización).

---

## Testing Conventions

These conventions apply to **all test types** (unit, integration, E2E) across the entire monorepo.

### Test Structure — Given / When / Then

Every test must follow the **Given / When / Then** pattern using comments or `describe` blocks:

```typescript
it('returns_error_when_mood_is_empty', () => {
  // Given
  const dto = { mood: '', note: 'some note' };

  // When
  const result = service.addMood(dto);

  // Then
  expect(result).toThrow(BadRequestException);
});
```

For longer scenarios, use nested `describe` blocks:

```typescript
describe('MoodsService', () => {
  describe('addMood', () => {
    describe('given a valid mood and note', () => {
      it('returns_added_status_with_new_entry', () => {
        // When
        const result = service.addMood({ mood: 'happy', note: 'great day' });

        // Then
        expect(result.status).toBe('added');
        expect(result.entry.mood).toBe('happy');
      });
    });
  });
});
```

### Naming Rules

- **Test names (`it`/`test`)**: `snake_case`, descriptive, no articles. Describe the observable behaviour, not the implementation.
  - Good: `returns_added_status_with_new_entry`
  - Good: `lists_moods_sorted_by_timestamp_descending`
  - Bad: `testAddMood`, `should work`, `test 1`
- **`describe` blocks**: plain prose, sentence-case, no trailing dot.
- **Test files**: `<subject>.spec.ts` for unit/integration; `<feature>.spec.ts` for E2E.

### Test Directories

| Layer | Test type | Location |
|---|---|---|
| Backend — moods feature | Unit + Integration | `backend/tests/moods/` |
| Frontend — app component | Component (unit) | `frontend/tests/app/` |
| Full stack | E2E (Playwright) | `e2e/` (repo root) |

Each test directory contains its own `AGENTS.md` with framework setup, commands, and patterns specific to that layer. Load the relevant guide before writing tests:

- **`backend/tests/moods/AGENTS.md`** — Jest + `@nestjs/testing`, unit and integration patterns
- **`frontend/tests/app/AGENTS.md`** — Jest + `jest-preset-angular` + Angular Testing Library
- **`e2e/AGENTS.md`** — Playwright, full-stack scenarios, port configuration
