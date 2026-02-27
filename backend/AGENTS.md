# AGENTS.md — Backend

NestJS 11 REST API. All commands must be run from this directory (`backend/`).

## Key Files

| File | Purpose |
|---|---|
| `src/main.ts` | Bootstrap, CORS config, port 3000 |
| `src/app.module.ts` | Root module — imports `MoodsModule` |
| `src/moods/` | Moods feature — see `src/moods/AGENTS.md` |
| `tsconfig.json` | TypeScript config (`strict: true`) |
| `tsconfig.build.json` | Build config — excludes spec files |
| `nest-cli.json` | NestJS CLI config |
| `Makefile` | Shorthand: `make dev` → `npm run start:dev` |

---

## Commands

```bash
# Install dependencies
npm install

# Development server (watch mode, auto-restart)
npm run start:dev
# or
make dev

# Production build → dist/
npm run build

# Start built output
npm start

# Type-check without emitting
npx tsc --noEmit
```

### Tests

**No test framework is installed.** There are no `*.spec.ts` files. When adding tests:

```bash
# Required setup — install once
npm install --save-dev jest ts-jest @types/jest @nestjs/testing

# Run all tests
npm test

# Run tests for a specific feature
npx jest tests/moods/

# Run a single test file
npx jest tests/moods/moods.service.spec.ts

# Run tests matching a name pattern
npx jest --testNamePattern="addMood"

# Watch mode
npx jest --watch
```

All tests live in a `tests/` directory at the same level as `src/`, organised by feature:

```
tests/
  moods/                     ← unit and integration tests for the moods feature
    AGENTS.md                ← framework setup, patterns, and commands
    moods.service.spec.ts    ← unit tests for MoodsService
    moods.controller.spec.ts ← integration tests for MoodsController
```

Load `tests/moods/AGENTS.md` for detailed setup and patterns before writing any test in this layer.

**Testing conventions** (applies to all tests in this backend):
- Structure every test with **Given / When / Then** comments.
- Name `it`/`test` blocks in `snake_case` describing observable behaviour, not implementation.
- See the root `AGENTS.md` Testing Conventions section for the full ruleset.

---

## TypeScript Configuration (`tsconfig.json`)

- `strict: true` — enforced. No implicit `any`, no unsafe assignments.
- `target: ES2022`
- `module: CommonJS` — required for NestJS/Node.js
- `emitDecoratorMetadata: true` — required for NestJS DI
- `experimentalDecorators: true`
- `skipLibCheck: true`
- `removeComments: true` on build

Do not disable `strict` or `emitDecoratorMetadata`.

---

## Module Structure

NestJS uses a module-per-feature pattern. The current structure:

```
src/
  main.ts              # entry point
  app.module.ts        # root module
  moods/               # moods feature module
    moods.module.ts
    moods.controller.ts
    moods.service.ts
    dto/
      create-mood.dto.ts
      mood-entry.dto.ts
      add-mood-response.dto.ts
      list-moods-response.dto.ts
tests/                 # all tests — at the same level as src/
  moods/               # tests for the moods feature — see tests/moods/AGENTS.md
```

When adding a new feature:
1. Create a `src/<feature>/` directory.
2. Add `<feature>.module.ts`, `<feature>.controller.ts`, `<feature>.service.ts`.
3. Add DTOs in `src/<feature>/dto/`.
4. Create a `tests/<feature>/` directory with its own `AGENTS.md`.
5. Import the new module in `src/app.module.ts`.

---

## Code Style

### Naming
- **Files**: `kebab-case` (e.g., `moods.service.ts`, `create-mood.dto.ts`)
- **Classes**: `PascalCase` (e.g., `MoodsService`, `CreateMoodDto`)
- **Interfaces**: `PascalCase` (e.g., `MoodEntry`, `AddMoodResponse`)
- **Variables/functions**: `camelCase`
- **Module-level constants**: `UPPER_SNAKE_CASE` (e.g., `DAY_NAMES`)

### Imports
- Named imports only. No default imports.
- Framework imports first (`@nestjs/*`), then internal imports (`./dto/...`).
- Use relative paths for internal imports.

### DI and Classes
- Use `private readonly` for all injected constructor parameters.
- Services decorated with `@Injectable()`. Controllers with `@Controller()`.
- Annotate all public methods with explicit return types.

```typescript
// Correct pattern
@Injectable()
export class MoodsService {
  addMood(data: CreateMoodDto): AddMoodResponse { ... }
  listMoods(): ListMoodsResponse { ... }
}
```

### DTOs
- Use `class` for request DTOs (required by NestJS `@Body()` binding).
- Use `interface` for response shapes and internal data types.
- All fields are optional by default — no `class-validator` is installed.

### Error Handling
- Use NestJS built-in HTTP exceptions: `NotFoundException`, `BadRequestException`, `InternalServerErrorException`, etc.
- Do not throw raw `Error` objects from controllers or services.
- No global exception filter is configured. Add one in `main.ts` with `app.useGlobalFilters()` if needed.

### Formatting
- 2-space indentation.
- Single quotes for strings.
- Semicolons required.
- Opening braces on the same line.
- No trailing commas in function parameters.
