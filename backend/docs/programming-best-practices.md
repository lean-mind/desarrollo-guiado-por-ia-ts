# Programming Best Practices — Backend

> Definición conceptual: [docs/programming-best-practices.md](../../docs/programming-best-practices.md)

Aplicación de los patrones de diseño al código NestJS de este proyecto.

---

## Factory Method

### Estado actual

La construcción de un `MoodEntry` está embebida directamente en `MoodsService.addMood()` (`src/moods/moods.service.ts`):

```typescript
// Construcción acoplada al servicio — sin factory
const entry: MoodEntry = {
  id: this.db.length + 1,
  mood: data.mood ?? 'unknown',
  note: data.note ?? '',
  timestamp: now.toISOString()...,
  date_formatted: ...,
  day_of_week: ...,
  is_weekend: ...,
};
```

No hay validaciones: cualquier valor llega al objeto sin restricción.

### Aplicación recomendada

Extraer una clase factoría en `src/moods/mood-entry.factory.ts` con constructor privado y método estático `create` que valida antes de construir:

```typescript
// src/moods/mood-entry.factory.ts
import { MoodEntry } from './dto/mood-entry.dto';

export class MoodEntryFactory {
  private constructor() {}

  static create(id: number, mood: string, note: string): MoodEntry {
    if (id <= 0) {
      throw new Error('id must be a positive integer');
    }
    if (!mood || mood.trim().length === 0) {
      throw new Error('mood is required');
    }
    if (mood.trim().length > 100) {
      throw new Error('mood exceeds maximum length of 100');
    }
    if (note.length > 500) {
      throw new Error('note exceeds maximum length of 500');
    }

    const now = new Date();
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return {
      id,
      mood: mood.trim(),
      note: note.trim(),
      timestamp: now.toISOString().replace('T', ' ').replace('Z', '').padEnd(26, '0'),
      date_formatted: now.toISOString().slice(0, 19).replace('T', ' '),
      day_of_week: days[now.getDay()],
      is_weekend: now.getDay() === 0 || now.getDay() === 6,
    };
  }
}
```

**Uso en el servicio:**

```typescript
// src/moods/moods.service.ts
const entry = MoodEntryFactory.create(this.db.length + 1, data.mood ?? '', data.note ?? '');
```

**Beneficio:** `MoodsService` deja de conocer la lógica de construcción. La factoría es testeable de forma aislada. La clase no es instanciable — `MoodEntryFactory` es un namespace de factoría puro.

---

## Value Objects

### Estado actual

`mood` y `note` son `string` sin restricciones. El servicio aplica un fallback pero no valida:

```typescript
// src/moods/moods.service.ts
mood: data.mood ?? 'unknown',  // cualquier string pasa
note: data.note ?? '',
```

### Aplicación recomendada

Definir Value Objects en `src/moods/value-objects/`:

```typescript
// src/moods/value-objects/mood.value-object.ts
export class Mood {
  private constructor(readonly value: string) {}

  static create(raw: string | undefined): Mood {
    const trimmed = (raw ?? '').trim();
    if (trimmed.length === 0) {
      return new Mood('unknown');
    }
    if (trimmed.length > 100) {
      throw new Error('mood exceeds maximum length of 100');
    }
    return new Mood(trimmed);
  }

  toString(): string {
    return this.value;
  }
}
```

```typescript
// src/moods/value-objects/note.value-object.ts
export class Note {
  private constructor(readonly value: string) {}

  static create(raw: string | undefined): Note {
    const trimmed = (raw ?? '').trim();
    if (trimmed.length > 500) {
      throw new Error('note exceeds maximum length of 500');
    }
    return new Note(trimmed);
  }

  toString(): string {
    return this.value;
  }
}
```

**Uso combinado con la factoría:**

```typescript
const mood = Mood.create(data.mood);
const note = Note.create(data.note);
const entry = MoodEntryFactory.create(this.db.length + 1, mood.toString(), note.toString());
```

**Beneficio:** las reglas de negocio del valor están en un único lugar. Imposible crear un `Mood` inválido.

---

## Repository Pattern

### Estado actual

El almacenamiento está embebido en el servicio como un array privado:

```typescript
// src/moods/moods.service.ts
@Injectable()
export class MoodsService {
  private db: MoodEntry[] = [];  // acoplado a la implementación concreta
  ...
}
```

### Aplicación recomendada

**1. Definir la interfaz del repositorio (puerto secundario):**

```typescript
// src/moods/repositories/mood.repository.ts
import { MoodEntry } from '../dto/mood-entry.dto';

export interface MoodRepository {
  save(entry: MoodEntry): MoodEntry;
  findAll(): MoodEntry[];
}

export const MOOD_REPOSITORY = Symbol('MoodRepository');
```

**2. Implementar el adaptador en memoria:**

```typescript
// src/moods/repositories/in-memory-mood.repository.ts
import { Injectable } from '@nestjs/common';
import { MoodEntry } from '../dto/mood-entry.dto';
import { MoodRepository } from './mood.repository';

@Injectable()
export class InMemoryMoodRepository implements MoodRepository {
  private entries: MoodEntry[] = [];

  save(entry: MoodEntry): MoodEntry {
    this.entries.push(entry);
    return entry;
  }

  findAll(): MoodEntry[] {
    return [...this.entries];
  }
}
```

**3. Inyectar en el servicio:**

```typescript
// src/moods/moods.service.ts
@Injectable()
export class MoodsService {
  constructor(
    @Inject(MOOD_REPOSITORY) private readonly repo: MoodRepository,
  ) {}

  addMood(data: CreateMoodDto): AddMoodResponse {
    const mood = Mood.create(data.mood);
    const note = Note.create(data.note);
    const entry = MoodEntryFactory.create(this.repo.findAll().length + 1, mood.toString(), note.toString());
    this.repo.save(entry);
    return { status: 'added', entry };
  }
}
```

**Beneficio:** para migrar a PostgreSQL o Redis basta con crear un nuevo `@Injectable()` que implemente `MoodRepository` y actualizar el módulo. El servicio no cambia.

---

## Relación entre los tres patrones

```
CreateMoodDto
     │
     ▼
Value Objects          ← validan y encapsulan los valores primitivos
(Mood, Note)
     │
     ▼
MoodEntryFactory       ← construye MoodEntry validando sus invariantes
  .create()
     │
     ▼
MoodRepository         ← persiste y recupera MoodEntry
  .save() / .findAll()
     │
     ▼
MoodsService           ← orquesta los tres patrones
```
