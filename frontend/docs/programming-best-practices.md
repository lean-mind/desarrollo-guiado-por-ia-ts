# Programming Best Practices — Frontend

> Definición conceptual: [docs/programming-best-practices.md](../../docs/programming-best-practices.md)

Aplicación de los patrones de diseño al código Angular de este proyecto.

---

## Factory Method

### Estado actual

La petición HTTP y la transformación de la respuesta se construyen inline directamente en el componente (`src/app/app.component.ts`):

```typescript
// Construcción acoplada al componente — sin factory
this.http.post(this.apiUrl + '/add', { mood, note }).subscribe(response => {
  this.moods = (response as any).moods;
});
```

No hay validaciones ni mapeo tipado. La respuesta se trata como `any`.

### Aplicación recomendada

Extraer una clase factoría en `src/app/mood-request.factory.ts` con constructor privado y métodos estáticos que validan antes de construir:

```typescript
// src/app/mood-request.factory.ts
import { MoodEntry } from './models/mood-entry.model';

export class MoodRequestFactory {
  private constructor() {}

  static createPayload(mood: string, note: string): { mood: string; note: string } {
    if (typeof mood !== 'string') {
      throw new Error('mood must be a string');
    }
    if (typeof note !== 'string') {
      throw new Error('note must be a string');
    }
    return {
      mood: mood.trim() || 'unknown',
      note: note.trim(),
    };
  }

  static fromResponse(raw: unknown): MoodEntry {
    if (!raw || typeof raw !== 'object') {
      throw new Error('invalid MoodEntry response: expected an object');
    }
    const r = raw as Record<string, unknown>;
    if (typeof r['id'] !== 'number') {
      throw new Error('invalid MoodEntry response: id must be a number');
    }
    if (typeof r['mood'] !== 'string') {
      throw new Error('invalid MoodEntry response: mood must be a string');
    }
    return raw as MoodEntry;
  }
}
```

**Uso en el componente:**

```typescript
// src/app/app.component.ts
addMood(rawMood: string, rawNote: string) {
  const payload = MoodRequestFactory.createPayload(rawMood, rawNote);
  this.http.post<{ entry: unknown }>(this.apiUrl + '/add', payload).subscribe({
    next: res => {
      MoodRequestFactory.fromResponse(res.entry);
      this.loadMoods();
    },
    error: err => console.error('Error al guardar:', err),
  });
}
```

**Beneficio:** la lógica de construcción y validación es testeable de forma aislada sin necesidad de montar el componente. La clase no es instanciable — `MoodRequestFactory` es un namespace de factoría puro.

---

## Value Objects

### Estado actual

Los valores se leen directamente de los `ElementRef` del template y se envían sin ninguna validación:

```typescript
// app.component.ts — sin Value Objects
addMood(mood: string, note: string) {
  this.http.post(this.apiUrl + '/add', { mood, note }).subscribe(...)
}
```

### Aplicación recomendada

Definir Value Objects en `src/app/value-objects/`:

```typescript
// src/app/value-objects/mood-input.value-object.ts
export class MoodInput {
  private constructor(readonly value: string) {}

  static create(raw: string): MoodInput {
    const trimmed = raw.trim();
    if (trimmed.length === 0) {
      return new MoodInput('unknown');
    }
    if (trimmed.length > 100) {
      throw new Error('mood exceeds maximum length of 100');
    }
    return new MoodInput(trimmed);
  }

  toString(): string {
    return this.value;
  }
}
```

```typescript
// src/app/value-objects/note-input.value-object.ts
export class NoteInput {
  private constructor(readonly value: string) {}

  static create(raw: string): NoteInput {
    const trimmed = raw.trim();
    if (trimmed.length > 500) {
      throw new Error('note exceeds maximum length of 500');
    }
    return new NoteInput(trimmed);
  }

  toString(): string {
    return this.value;
  }
}
```

**Uso combinado con la factoría:**

```typescript
addMood(rawMood: string, rawNote: string) {
  const mood = MoodInput.create(rawMood);
  const note = NoteInput.create(rawNote);
  const payload = MoodRequestFactory.createPayload(mood.toString(), note.toString());
  this.http.post(this.apiUrl + '/add', payload).subscribe(...);
}
```

**Beneficio:** la validación ocurre antes de la llamada HTTP. Los errores de validación se pueden mostrar en la UI sin depender de la respuesta del backend.

---

## Repository Pattern

### Estado actual

El componente inyecta `HttpClient` directamente y construye las URLs inline:

```typescript
// app.component.ts — acoplado a HttpClient y a la URL
private apiUrl = 'http://localhost:8000';  // inconsistencia: debería ser 3000

loadMoods() {
  this.http.get<any>(this.apiUrl + '/list').subscribe(response => {
    this.moods = response.moods;
  });
}
```

### Aplicación recomendada

**1. Definir la interfaz del repositorio (puerto secundario):**

```typescript
// src/app/repositories/mood.repository.ts
import { InjectionToken } from '@angular/core';
import { Observable } from 'rxjs';
import { MoodEntry } from '../models/mood-entry.model';

export interface MoodRepository {
  add(mood: string, note: string): Observable<MoodEntry>;
  list(): Observable<MoodEntry[]>;
}

export const MOOD_REPOSITORY = new InjectionToken<MoodRepository>('MoodRepository');
```

**2. Implementar el adaptador HTTP:**

```typescript
// src/app/repositories/http-mood.repository.ts
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { MoodEntry } from '../models/mood-entry.model';
import { MoodRepository } from './mood.repository';

@Injectable({ providedIn: 'root' })
export class HttpMoodRepository implements MoodRepository {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = 'http://localhost:3000';

  add(mood: string, note: string): Observable<MoodEntry> {
    return this.http
      .post<{ entry: MoodEntry }>(this.apiUrl + '/add', { mood, note })
      .pipe(map(res => res.entry));
  }

  list(): Observable<MoodEntry[]> {
    return this.http
      .get<{ moods: MoodEntry[] }>(this.apiUrl + '/list')
      .pipe(map(res => res.moods));
  }
}
```

**3. El componente solo conoce el repositorio:**

```typescript
// app.component.ts
export class AppComponent {
  private readonly repo = inject(HttpMoodRepository);
  moods: MoodEntry[] = [];

  loadMoods() {
    this.repo.list().subscribe(moods => (this.moods = moods));
  }

  addMood(rawMood: string, rawNote: string) {
    const mood = MoodInput.create(rawMood).toString();
    const note = NoteInput.create(rawNote).toString();
    this.repo.add(mood, note).subscribe(() => this.loadMoods());
  }
}
```

**Beneficio:** para tests unitarios del componente se puede inyectar un `MockMoodRepository` sin realizar peticiones HTTP reales.

---

## Modelo de dominio tipado

Paso previo necesario para los patrones anteriores. Elimina el `any[]` actual:

```typescript
// src/app/models/mood-entry.model.ts
export interface MoodEntry {
  id: number;
  mood: string;
  note: string;
  timestamp: string;
  date_formatted: string;
  day_of_week: string;
  is_weekend: boolean;
  age_in_seconds?: number;
}
```

Este modelo debe mantenerse sincronizado con `backend/src/moods/dto/mood-entry.dto.ts`.

---

## Relación entre los tres patrones

```
Template (input del usuario)
     │
     ▼
Value Objects              ← validan antes de enviar
(MoodInput, NoteInput)
     │
     ▼
MoodRequestFactory         ← construye el payload / valida la respuesta
  .createPayload()
  .fromResponse()
     │
     ▼
MoodRepository             ← abstrae la comunicación HTTP
  HttpMoodRepository
     │
     ▼
AppComponent               ← orquesta, no conoce detalles HTTP
```
