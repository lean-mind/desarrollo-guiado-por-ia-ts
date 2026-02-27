# AGENTS.md — Moods Tests (Unit + Integration)

Tests for the moods feature. All commands must be run from `backend/`.

---

## Setup

No test framework is installed yet. Install once before writing any test:

```bash
npm install --save-dev jest ts-jest @types/jest @nestjs/testing
```

Add the following to `backend/package.json`:

```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage"
  },
  "jest": {
    "moduleFileExtensions": ["js", "json", "ts"],
    "rootDir": "src",
    "testRegex": ".spec.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
```

---

## Commands

```bash
# Run all moods tests
npx jest src/moods/tests/

# Run only unit tests
npx jest src/moods/tests/moods.service.spec.ts

# Run only integration tests
npx jest src/moods/tests/moods.controller.spec.ts

# Run tests matching a name pattern
npx jest --testNamePattern="addMood"

# Watch mode (re-runs on file change)
npx jest --watch

# Coverage report
npx jest --coverage
```

---

## Test Types

### Unit Tests — `moods.service.spec.ts`

Test `MoodsService` in isolation. No HTTP, no NestJS module bootstrap.
Instantiate the service directly with `new MoodsService()`.

```typescript
import { MoodsService } from '../moods.service';

describe('MoodsService', () => {
  let service: MoodsService;

  beforeEach(() => {
    // Given — fresh service (empty in-memory db) for each test
    service = new MoodsService();
  });

  describe('addMood', () => {
    describe('given a valid mood and note', () => {
      it('returns_added_status_with_new_entry', () => {
        // When
        const result = service.addMood({ mood: 'happy', note: 'great day' });

        // Then
        expect(result.status).toBe('added');
        expect(result.entry.mood).toBe('happy');
        expect(result.entry.note).toBe('great day');
        expect(result.entry.id).toBe(1);
      });
    });

    describe('given no mood is provided', () => {
      it('defaults_mood_to_unknown', () => {
        // When
        const result = service.addMood({});

        // Then
        expect(result.entry.mood).toBe('unknown');
      });
    });
  });

  describe('listMoods', () => {
    describe('given multiple moods have been added', () => {
      it('returns_moods_sorted_by_timestamp_descending', () => {
        // Given
        service.addMood({ mood: 'sad' });
        service.addMood({ mood: 'happy' });

        // When
        const result = service.listMoods();

        // Then
        expect(result.moods[0].mood).toBe('happy');
        expect(result.moods[1].mood).toBe('sad');
      });

      it('includes_age_in_seconds_for_each_entry', () => {
        // Given
        service.addMood({ mood: 'calm' });

        // When
        const result = service.listMoods();

        // Then
        expect(typeof result.moods[0].age_in_seconds).toBe('number');
        expect(result.moods[0].age_in_seconds).toBeGreaterThanOrEqual(0);
      });
    });

    describe('given no moods have been added', () => {
      it('returns_empty_list_with_zero_count', () => {
        // When
        const result = service.listMoods();

        // Then
        expect(result.moods).toHaveLength(0);
        expect(result.count).toBe(0);
      });
    });
  });
});
```

### Integration Tests — `moods.controller.spec.ts`

Test the full NestJS request/response cycle using `@nestjs/testing`.
Bootstrap only the `MoodsModule` — no real HTTP server.

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { MoodsController } from '../moods.controller';
import { MoodsService } from '../moods.service';
import { CreateMoodDto } from '../dto/create-mood.dto';

describe('MoodsController', () => {
  let controller: MoodsController;
  let service: MoodsService;

  beforeEach(async () => {
    // Given — isolated NestJS testing module
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MoodsController],
      providers: [MoodsService],
    }).compile();

    controller = module.get<MoodsController>(MoodsController);
    service = module.get<MoodsService>(MoodsService);
  });

  describe('addMood', () => {
    describe('given a valid CreateMoodDto', () => {
      it('delegates_to_service_and_returns_result', () => {
        // Given
        const dto: CreateMoodDto = { mood: 'excited', note: 'launch day' };

        // When
        const result = controller.addMood(dto);

        // Then
        expect(result.status).toBe('added');
        expect(result.entry.mood).toBe('excited');
      });
    });
  });

  describe('listMoods', () => {
    describe('given moods exist in the service', () => {
      it('returns_count_matching_number_of_entries', () => {
        // Given
        service.addMood({ mood: 'calm' });
        service.addMood({ mood: 'tired' });

        // When
        const result = controller.listMoods();

        // Then
        expect(result.count).toBe(2);
        expect(result.moods).toHaveLength(2);
      });
    });
  });
});
```

---

## Naming Rules

- **File names**: `<subject>.spec.ts` (e.g., `moods.service.spec.ts`, `moods.controller.spec.ts`).
- **`it`/`test` names**: `snake_case`, no articles, describe observable behaviour.
  - Good: `returns_added_status_with_new_entry`
  - Bad: `should return added`, `testAddMood`
- **`describe` blocks**: plain prose, sentence-case.

---

## Patterns and Rules

- Each `it` block must use **Given / When / Then** comments (or nested `describe` blocks for Given).
- Use `beforeEach` to reset state — never share mutable state between tests.
- Unit tests instantiate classes directly (`new MoodsService()`). No `Test.createTestingModule` needed.
- Integration tests use `Test.createTestingModule` and wire real providers — do **not** mock `MoodsService` unless testing error paths that require controlled responses.
- Do not make real HTTP requests in integration tests — use the controller/service directly.
- `MoodsService` stores data in memory; each `beforeEach` must create a fresh instance to prevent test pollution.
