# AGENTS.md — App Component Tests (Unit / Component)

Tests for `AppComponent`. All commands must be run from `frontend/`.

---

## Setup

No test framework is installed yet. Install once before writing any test:

```bash
npm install --save-dev jest jest-preset-angular @testing-library/angular @types/jest
```

Create `frontend/jest.config.ts`:

```typescript
import type { Config } from 'jest';

const config: Config = {
  preset: 'jest-preset-angular',
  setupFilesAfterFramework: ['<rootDir>/setup-jest.ts'],
  testPathPattern: 'src/app/tests/.*\\.spec\\.ts$',
  moduleNameMapper: {
    '^src/(.*)$': '<rootDir>/src/$1',
  },
};

export default config;
```

Create `frontend/setup-jest.ts`:

```typescript
import 'jest-preset-angular/setup-jest';
```

Add the following to `frontend/package.json`:

```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage"
  }
}
```

---

## Commands

```bash
# Run all component tests
npm test

# Run a single test file
npx jest src/app/tests/app.component.spec.ts

# Run tests matching a name pattern
npx jest --testNamePattern="loadsMoods"

# Watch mode (re-runs on file change)
npx jest --watch

# Coverage report
npx jest --coverage
```

---

## Test Type — Component Tests (`app.component.spec.ts`)

Use **Angular Testing Library** (`@testing-library/angular`) for component tests.
Render the component, interact via queries, and assert on the DOM and HTTP calls.

```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { AppComponent } from '../app.component';

describe('AppComponent', () => {
  describe('on initialization', () => {
    it('loads_and_displays_moods_from_api', async () => {
      // Given
      const { fixture } = await render(AppComponent, {
        imports: [HttpClientTestingModule],
      });
      const httpMock = fixture.debugElement.injector.get(HttpTestingController);

      // When
      const req = httpMock.expectOne('http://localhost:3000/list');
      req.flush({
        moods: [
          {
            id: 1,
            mood: 'happy',
            note: 'great day',
            date_formatted: '2026-01-01 10:00:00',
            day_of_week: 'Wednesday',
            is_weekend: false,
            age_in_seconds: 60,
          },
        ],
        count: 1,
      });
      fixture.detectChanges();

      // Then
      expect(screen.getByText('happy')).toBeInTheDocument();
      httpMock.verify();
    });
  });

  describe('when submitting the add mood form', () => {
    it('posts_mood_to_api_and_refreshes_list', async () => {
      // Given
      const { fixture } = await render(AppComponent, {
        imports: [HttpClientTestingModule],
      });
      const httpMock = fixture.debugElement.injector.get(HttpTestingController);

      // Flush initial GET /list
      httpMock.expectOne(/\/list/).flush({ moods: [], count: 0 });
      fixture.detectChanges();

      // When — fill in the form and submit
      await userEvent.type(screen.getByLabelText(/mood/i), 'calm');
      await userEvent.click(screen.getByRole('button', { name: /add/i }));

      const postReq = httpMock.expectOne(/\/add/);

      // Then
      expect(postReq.request.method).toBe('POST');
      expect(postReq.request.body).toMatchObject({ mood: 'calm' });
      httpMock.verify();
    });
  });
});
```

---

## Naming Rules

- **File names**: `<subject>.spec.ts` (e.g., `app.component.spec.ts`).
- **`it`/`test` names**: `snake_case`, no articles, describe observable behaviour.
  - Good: `loads_and_displays_moods_from_api`
  - Bad: `should load moods`, `testLoadMoods`
- **`describe` blocks**: plain prose, sentence-case.

---

## Patterns and Rules

- Every `it` block must use **Given / When / Then** comments.
- Use `HttpClientTestingModule` and `HttpTestingController` to intercept HTTP — never make real network calls.
- Always call `httpMock.verify()` at the end of each test to assert no unexpected requests remain.
- Use `fixture.detectChanges()` after flushing HTTP responses to trigger Angular's change detection.
- Query the DOM via Testing Library queries (`getByText`, `getByRole`, `getByLabelText`) — not `querySelector`.
- Do not use `async/await` with `fakeAsync`/`tick` — use the `async` variant from Testing Library consistently.
- `strict: false` is set in `tsconfig.json`; new test code may use `any` where necessary, but prefer explicit types.
