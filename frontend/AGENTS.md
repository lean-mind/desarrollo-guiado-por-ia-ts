# AGENTS.md — Frontend

Angular 21 SPA. All commands must be run from this directory (`frontend/`).

## Key Files

| File | Purpose |
|---|---|
| `src/main.ts` | Bootstrap — provides `HttpClient` with `withFetch()` |
| `src/app/app.component.ts` | Single standalone component — all UI and HTTP logic |
| `src/index.html` | Shell HTML, mounts `<app-root>` |
| `tsconfig.json` | TypeScript config (`strict: false`) |
| `tsconfig.app.json` | App build config — extends `tsconfig.json` |
| `angular.json` | Angular CLI workspace config |

---

## Commands

```bash
# Install dependencies
npm install

# Development server (http://localhost:4200, live reload)
npm start

# Production build → dist/
npm run build

# Watch mode (dev build, recompiles on change)
npm run watch

# Type-check without emitting
npx tsc --noEmit
```

### Tests

**No test framework is installed.** There are no `*.spec.ts` files. When adding tests:

```bash
# Required setup — install once
npm install --save-dev jest jest-preset-angular @testing-library/angular @types/jest

# Run all tests
npm test

# Run a single test file
npx jest tests/app/app.component.spec.ts

# Run tests matching a name pattern
npx jest --testNamePattern="loadsMoods"

# Watch mode
npx jest --watch
```

All tests live in a `tests/` directory at the same level as `src/`, organised by component:

```
tests/
  app/                            ← tests for AppComponent
    AGENTS.md                     ← framework setup, patterns, and commands
    app.component.spec.ts         ← component tests using Angular Testing Library
```

Load `tests/app/AGENTS.md` for detailed setup and patterns before writing any test in this layer.

**Testing conventions** (applies to all tests in this frontend):
- Structure every test with **Given / When / Then** comments.
- Name `it`/`test` blocks in `snake_case` describing observable behaviour, not implementation.
- See the root `AGENTS.md` Testing Conventions section for the full ruleset.

---

## TypeScript Configuration (`tsconfig.json`)

- `strict: false` — **all strict checks are disabled**. This is intentional; match existing code.
- `target: ES2022`
- `module: ES2022`
- `moduleResolution: "bundler"` — Angular 21 Vite-compatible resolution
- `useDefineForClassFields: false` — required for Angular decorators to work
- `experimentalDecorators: true`

Do not enable `strict` without also refactoring the entire component.

---

## Application Structure

The app currently has a single standalone component. There is no routing, no NgModules, no lazy loading.

```
src/
  main.ts                  # bootstrapApplication entry point
  index.html               # shell
  app/
    app.component.ts       # entire app — template, styles, and logic inline
tests/                     # all tests — at the same level as src/
  app/                     # tests for AppComponent — see tests/app/AGENTS.md
```

`HttpClient` is provided globally via `provideHttpClient(withFetch())` in `src/main.ts:6-8`.

---

## Component Model

The existing `AppComponent` (`src/app/app.component.ts`) uses the **standalone component** pattern:

```typescript
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],   // add Angular modules here, not in an NgModule
  template: `...`,           // inline template
  styles: [``]
})
export class AppComponent { ... }
```

Rules for new components:
- Always use `standalone: true`. Never create NgModules.
- List all required Angular modules (`CommonModule`, `FormsModule`, `ReactiveFormsModule`, etc.) in the `imports` array of the component itself.
- Use inline `template:` for small/medium templates. Extract to `templateUrl:` only for large templates.
- New components go in `src/app/<feature>/` subdirectories.

---

## HTTP Client

`HttpClient` is injected in the constructor and used with the Observable `subscribe()` pattern. Always provide both `next` and `error` callbacks:

```typescript
this.http.post(`${this.apiUrl}/add`, data).subscribe({
  next: (response: any) => { ... },
  error: (err: any) => { console.error('Error:', err); }
});
```

- The API base URL is `private apiUrl = 'http://localhost:8000'` in `app.component.ts:57`.
  **Known inconsistency**: the backend runs on port `3000` by default. Change this to `http://localhost:3000` for local development.
- Do not hard-code the URL in multiple places; keep it as a single class field.
- Do not swallow errors silently — at minimum log them with `console.error`.

---

## Code Style

### Naming
- **Files**: `kebab-case` (e.g., `app.component.ts`, `mood-list.component.ts`)
- **Classes**: `PascalCase` (e.g., `AppComponent`)
- **Variables/methods**: `camelCase`
- Component selectors: `app-*` prefix (e.g., `app-root`, `app-mood-list`)

### Types
- `strict: false` is in effect. The existing code uses `any` broadly.
- Prefer typed variables in new code, but do not refactor existing `any` unless explicitly asked.
- Template variables use `#ref` syntax for template references (e.g., `#moodInput`).

### Templates
- Use `*ngFor`, `*ngIf` (from `CommonModule`) for structural directives.
- Use `(click)`, `(input)`, `(submit)` for event bindings.
- Use `{{ expression }}` for interpolation.
- Inline styles are used throughout the existing component — follow suit for minor changes, but prefer a `styles` array or external stylesheet for new components.

### Formatting
- 2-space indentation.
- Single quotes for strings.
- Semicolons required.
- Opening braces on the same line.
