# AGENTS.md — E2E Tests (Playwright)

Full-stack end-to-end tests for the Mood Tracker application. All commands must be run from this directory (`e2e/`).

---

## Prerequisites

Both the backend and frontend must be running before E2E tests execute:

| Service | URL |
|---|---|
| Backend (NestJS) | `http://localhost:3000` |
| Frontend (Angular) | `http://localhost:4200` |

Start both services first:

```bash
# Terminal 1 — from backend/
npm run start:dev

# Terminal 2 — from frontend/
npm start
```

**Known inconsistency**: `frontend/src/app/app.component.ts:57` has `apiUrl` hardcoded to `http://localhost:8000`. Change it to `http://localhost:3000` before running E2E tests, or the frontend will not connect to the backend.

---

## Setup

No Playwright installation exists yet. Install once from the `e2e/` directory:

```bash
# Initialise a package.json for this directory
npm init -y

# Install Playwright
npm install --save-dev @playwright/test

# Download browser binaries
npx playwright install
```

Create `e2e/playwright.config.ts`:

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: '.',
  testMatch: '**/*.spec.ts',
  timeout: 30_000,
  use: {
    baseURL: 'http://localhost:4200',
    headless: true,
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
```

---

## Commands

```bash
# Run all E2E tests (requires both services running)
npx playwright test

# Run a single spec file
npx playwright test moods.spec.ts

# Run tests matching a name pattern
npx playwright test --grep "add_mood"

# Run in headed mode (opens browser window — useful for debugging)
npx playwright test --headed

# Show HTML report after a run
npx playwright show-report

# Debug a failing test interactively
npx playwright test --debug moods.spec.ts
```

---

## Test Structure

E2E specs live directly in `e2e/` (no subdirectory):

```
e2e/
  AGENTS.md
  playwright.config.ts
  moods.spec.ts          ← full-stack scenarios for the moods feature
```

---

## Writing Tests

Use the **Given / When / Then** pattern. Every `test` block must include comments for all three phases.

```typescript
import { test, expect } from '@playwright/test';

test.describe('Moods feature', () => {
  test.describe('given the application is loaded', () => {
    test('displays_empty_mood_list_on_first_visit', async ({ page }) => {
      // Given
      await page.goto('/');

      // When — page is loaded, initial GET /list completes
      await page.waitForSelector('[data-testid="mood-list"]');

      // Then
      const items = page.locator('[data-testid="mood-item"]');
      await expect(items).toHaveCount(0);
    });
  });

  test.describe('given the user fills in the add mood form', () => {
    test('submits_mood_and_displays_it_in_the_list', async ({ page }) => {
      // Given
      await page.goto('/');

      // When
      await page.fill('[data-testid="mood-input"]', 'happy');
      await page.fill('[data-testid="note-input"]', 'great day');
      await page.click('[data-testid="submit-button"]');

      // Then
      await expect(page.locator('[data-testid="mood-item"]').first()).toContainText('happy');
    });
  });

  test.describe('given moods already exist', () => {
    test('lists_moods_sorted_newest_first', async ({ page }) => {
      // Given — add two moods in order
      await page.goto('/');
      await page.fill('[data-testid="mood-input"]', 'tired');
      await page.click('[data-testid="submit-button"]');
      await page.fill('[data-testid="mood-input"]', 'energised');
      await page.click('[data-testid="submit-button"]');

      // When — list is refreshed
      await page.waitForTimeout(200);

      // Then — most recent appears first
      const items = page.locator('[data-testid="mood-item"]');
      await expect(items.first()).toContainText('energised');
    });
  });
});
```

---

## Naming Rules

- **File names**: `<feature>.spec.ts` (e.g., `moods.spec.ts`).
- **`test` names**: `snake_case`, no articles, describe what the user observes.
  - Good: `submits_mood_and_displays_it_in_the_list`
  - Bad: `should add mood`, `testAddMood`
- **`test.describe` blocks**: plain prose, sentence-case.

---

## Patterns and Rules

- Every `test` block must follow **Given / When / Then** with comments.
- Use `data-testid` attributes to select elements — never CSS class names or tag selectors. Add `data-testid` to the Angular template when needed.
- Use `await expect(...).toBeVisible()` / `toHaveText()` / `toHaveCount()` for assertions — never raw boolean checks.
- Tests are **not** isolated from each other by default — the backend's in-memory state persists across tests in the same run. Use `test.beforeEach` to navigate to a clean state, or reset via a dedicated backend endpoint if one exists.
- Do not add artificial `waitForTimeout` delays — use `waitForSelector`, `waitForResponse`, or Playwright auto-waiting instead (the example above is for illustration only).
- Each test must be independently runnable; do not rely on test execution order.
