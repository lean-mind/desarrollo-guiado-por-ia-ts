# Validaciones con Zod — Backend

Guía para introducir validaciones de entrada con [Zod](https://zod.dev) en el backend NestJS.

---

## Estado actual

El backend **no tiene librería de validación instalada**. `class-validator` y `class-transformer` no están presentes. Los campos de `CreateMoodDto` son opcionales sin ninguna restricción:

```typescript
// src/moods/dto/create-mood.dto.ts
export class CreateMoodDto {
  mood?: string;
  note?: string;
}
```

El servicio aplica fallbacks silenciosos (`?? 'unknown'`, `?? ''`) en lugar de rechazar entradas inválidas con un error HTTP claro.

---

## Por qué Zod

Zod es una librería de validación y parsing basada en esquemas TypeScript-first. A diferencia de `class-validator`:

| Característica | `class-validator` | Zod |
|---|---|---|
| Inferencia de tipos | Manual (decoradores) | Automática desde el esquema |
| Runtime parsing | Requiere `class-transformer` | Incluido en Zod |
| Sin decoradores | No | Sí — funciona con interfaces y objetos planos |
| Integración NestJS | `ValidationPipe` nativo | Requiere un `ZodValidationPipe` personalizado |

---

## Instalación

```bash
npm install zod
```

No se requieren dependencias adicionales. `class-validator` y `class-transformer` **no** son necesarios con este enfoque.

---

## Definir el esquema

Crear el esquema en `src/moods/dto/create-mood.schema.ts`:

```typescript
// src/moods/dto/create-mood.schema.ts
import { z } from 'zod';

export const CreateMoodSchema = z.object({
  mood: z
    .string({ invalid_type_error: 'mood must be a string' })
    .trim()
    .min(1, 'mood cannot be empty')
    .max(100, 'mood exceeds maximum length of 100')
    .optional()
    .default('unknown'),
  note: z
    .string({ invalid_type_error: 'note must be a string' })
    .trim()
    .max(500, 'note exceeds maximum length of 500')
    .optional()
    .default(''),
});

export type CreateMoodDto = z.infer<typeof CreateMoodSchema>;
```

`z.infer<>` genera el tipo TypeScript directamente desde el esquema: una única fuente de verdad para tipo y validación.

---

## Crear un ZodValidationPipe

NestJS no incluye soporte nativo para Zod. Se necesita un `PipeTransform` personalizado en `src/common/pipes/zod-validation.pipe.ts`:

```typescript
// src/common/pipes/zod-validation.pipe.ts
import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { ZodSchema } from 'zod';

@Injectable()
export class ZodValidationPipe implements PipeTransform {
  constructor(private readonly schema: ZodSchema) {}

  transform(value: unknown): unknown {
    const result = this.schema.safeParse(value);
    if (!result.success) {
      throw new BadRequestException({
        message: 'Validation failed',
        errors: result.error.errors.map(e => ({
          field: e.path.join('.'),
          message: e.message,
        })),
      });
    }
    return result.data;
  }
}
```

`safeParse` nunca lanza — devuelve `{ success: true, data }` o `{ success: false, error }`. El pipe transforma los errores de Zod en un `BadRequestException` con formato JSON consistente.

---

## Aplicar el pipe en el controlador

```typescript
// src/moods/moods.controller.ts
import { Body, Controller, Post, UsePipes } from '@nestjs/common';
import { ZodValidationPipe } from '../common/pipes/zod-validation.pipe';
import { CreateMoodSchema, CreateMoodDto } from './dto/create-mood.schema';
import { MoodsService } from './moods.service';

@Controller()
export class MoodsController {
  constructor(private readonly moodsService: MoodsService) {}

  @Post('add')
  @UsePipes(new ZodValidationPipe(CreateMoodSchema))
  addMood(@Body() data: CreateMoodDto) {
    return this.moodsService.addMood(data);
  }
}
```

El pipe se aplica a nivel de método con `@UsePipes`. El `@Body()` recibe el objeto ya parseado y transformado por Zod (con `trim()` y `default()` aplicados).

---

## Formato de error

Cuando la validación falla, la respuesta tiene esta forma:

```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "errors": [
    { "field": "mood", "message": "mood exceeds maximum length of 100" }
  ]
}
```

---

## Estructura de archivos resultante

```
src/
  common/
    pipes/
      zod-validation.pipe.ts     ← pipe reutilizable para cualquier esquema Zod
  moods/
    dto/
      create-mood.schema.ts      ← esquema Zod + tipo inferido (reemplaza create-mood.dto.ts)
      mood-entry.dto.ts          ← sin cambios
      add-mood-response.dto.ts   ← sin cambios
      list-moods-response.dto.ts ← sin cambios
```

---

## Relación con Value Objects y Factory Method

Con Zod, la validación de entrada ocurre en la capa de adaptador (el pipe), **antes** de llegar al dominio. Los Value Objects y el Factory Method pueden simplificarse o eliminarse para `mood` y `note`, ya que Zod garantiza que los valores llegan saneados al servicio:

```
HTTP Request (body crudo)
     │
     ▼
ZodValidationPipe          ← valida, sanea y aplica defaults
     │
     ▼
MoodsController            ← recibe CreateMoodDto ya válido
     │
     ▼
MoodsService / Factory     ← puede asumir que los valores son correctos
```

Si se mantienen los Value Objects, el Factory Method puede delegar la validación al pipe y usar los Value Objects solo para encapsular semántica de dominio, no para protección contra entradas inválidas.
