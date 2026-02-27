# AGENTS.md — Moods Feature

This is the only feature module in the backend. It owns the full HTTP surface of the API.

## Files in This Directory

| File | Responsibility |
|---|---|
| `moods.module.ts` | NestJS module — wires controller + service |
| `moods.controller.ts` | HTTP routing: `POST /add`, `GET /list` |
| `moods.service.ts` | Business logic, in-memory storage |
| `dto/create-mood.dto.ts` | Request body shape for `POST /add` |
| `dto/mood-entry.dto.ts` | Core data types: `MoodEntry`, `MoodEntryWithAge` |
| `dto/add-mood-response.dto.ts` | Response shape for `POST /add` |
| `dto/list-moods-response.dto.ts` | Response shape for `GET /list` |
| `tests/` | Unit and integration tests — see `backend/tests/moods/AGENTS.md` |

---

## Data Flow

```
POST /add  →  MoodsController.addMood()  →  MoodsService.addMood()  →  in-memory db[]
GET /list  →  MoodsController.listMoods() →  MoodsService.listMoods() → sorted + age calc
```

---

## DTOs

### `CreateMoodDto` (`dto/create-mood.dto.ts`)
```typescript
export class CreateMoodDto {
  mood?: string;   // defaults to 'unknown' in service if absent
  note?: string;   // defaults to '' in service if absent
}
```
- Must be a `class` (not interface) so NestJS can instantiate it from `@Body()`.
- No `class-validator` decorators — both fields are always optional.

### `MoodEntry` / `MoodEntryWithAge` (`dto/mood-entry.dto.ts`)
```typescript
export interface MoodEntry {
  id: number;
  mood: string;
  note: string;
  timestamp: string;        // ISO-like: "YYYY-MM-DDTHH:mm:ss.ffffff"
  date_formatted: string;   // "YYYY-MM-DD HH:mm:ss"
  day_of_week: string;      // "Sunday" … "Saturday"
  is_weekend: boolean;
}

export interface MoodEntryWithAge extends MoodEntry {
  age_in_seconds: number;
}
```
**These are the shared contract with the frontend.** Any field rename or type change must be reflected in `frontend/src/app/app.component.ts` (template reads `item.mood`, `item.note`, `item.date_formatted`, `item.day_of_week`).

### Response DTOs
- `AddMoodResponse` (`dto/add-mood-response.dto.ts`): `{ status: 'added', entry: MoodEntry }`
- `ListMoodsResponse` (`dto/list-moods-response.dto.ts`): `{ moods: MoodEntryWithAge[], count: number }`

---

## Service Details (`moods.service.ts`)

- Storage: `private db: MoodEntry[] = []` — in-memory, cleared on restart.
- IDs are sequential integers starting at 1: `id: this.db.length + 1`.
- `timestamp` uses microsecond-padded format to match Python's `isoformat()` output (historical compatibility).
- `listMoods()` returns entries **sorted descending by timestamp** and adds `age_in_seconds` to each.
- No persistence layer. If you add a database, inject a repository service and replace the `db` array.

---

## Controller Details (`moods.controller.ts`)

- `@Controller()` with no path prefix — routes are `/add` and `/list` at the root.
- Both methods delegate entirely to `MoodsService` — no logic in the controller.
- Return types are explicitly annotated (`AddMoodResponse`, `ListMoodsResponse`).

---

## Adding a New Endpoint

1. Add a method to `MoodsService` with explicit return type.
2. Add a corresponding `@Get()` / `@Post()` / etc. method to `MoodsController`.
3. Create a new DTO file in `dto/` if the response shape is new.
4. Add corresponding unit and integration tests in `backend/tests/moods/`.
5. Update the root `AGENTS.md` API contract table if the endpoint is part of the public surface.
6. Notify that the frontend may need updating if the response shape changes.

---

## Tests

Tests for this feature live in `backend/tests/moods/` (at the same level as `src/`). Load `backend/tests/moods/AGENTS.md` for the full setup guide, commands, and code patterns before writing any test for this feature.

**Summary of conventions:**
- Framework: Jest + `ts-jest` + `@nestjs/testing`
- Unit tests (`moods.service.spec.ts`): instantiate `MoodsService` directly.
- Integration tests (`moods.controller.spec.ts`): use `Test.createTestingModule`.
- Every `it` block must follow **Given / When / Then**.
- Test names in `snake_case`.
