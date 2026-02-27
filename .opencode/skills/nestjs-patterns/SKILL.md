---
name: nestjs-patterns
description: Patrones y convenciones de NestJS 11 usados en el proyecto Mood Tracker. Carga este skill cuando necesites crear nuevos modulos, controladores, servicios o DTOs siguiendo la estructura existente.
---

## Patron Modular de NestJS

Cada recurso del proyecto sigue esta estructura:

```
src/<recurso>/
├── <recurso>.module.ts        # Modulo que registra controller y service
├── <recurso>.controller.ts    # Controlador con endpoints REST
├── <recurso>.service.ts       # Logica de negocio
└── dto/
    ├── create-<recurso>.dto.ts       # DTO de entrada para crear
    ├── <recurso>-entry.dto.ts        # DTO de la entidad
    ├── add-<recurso>-response.dto.ts # DTO de respuesta al crear
    └── list-<recurso>s-response.dto.ts # DTO de respuesta al listar
```

## Ejemplo: Crear un Modulo Nuevo

### 1. DTO de entrada

```typescript
// src/example/dto/create-example.dto.ts
export class CreateExampleDto {
  name: string;
  value: number;
}
```

### 2. DTO de entidad

```typescript
// src/example/dto/example-entry.dto.ts
export class ExampleEntry {
  id: string;
  name: string;
  value: number;
  timestamp: string;
}
```

### 3. DTOs de respuesta

```typescript
// src/example/dto/add-example-response.dto.ts
export class AddExampleResponse {
  success: boolean;
  entry: ExampleEntry;
}

// src/example/dto/list-examples-response.dto.ts
export class ListExamplesResponse {
  entries: ExampleEntry[];
  count: number;
}
```

### 4. Service (logica de negocio)

```typescript
// src/example/example.service.ts
import { Injectable } from '@nestjs/common';
import { CreateExampleDto } from './dto/create-example.dto';
import { ExampleEntry } from './dto/example-entry.dto';
import { v4 as uuidv4 } from 'uuid'; // o usa crypto.randomUUID()

@Injectable()
export class ExampleService {
  private entries: ExampleEntry[] = [];

  add(dto: CreateExampleDto): ExampleEntry {
    const entry: ExampleEntry = {
      id: crypto.randomUUID(),
      ...dto,
      timestamp: new Date().toISOString(),
    };
    this.entries.push(entry);
    return entry;
  }

  list(): ExampleEntry[] {
    return [...this.entries].sort(
      (a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime()
    );
  }
}
```

### 5. Controller (endpoints)

```typescript
// src/example/example.controller.ts
import { Controller, Get, Post, Body } from '@nestjs/common';
import { ExampleService } from './example.service';
import { CreateExampleDto } from './dto/create-example.dto';
import { AddExampleResponse } from './dto/add-example-response.dto';
import { ListExamplesResponse } from './dto/list-examples-response.dto';

@Controller()
export class ExampleController {
  constructor(private readonly exampleService: ExampleService) {}

  @Post('add-example')
  add(@Body() dto: CreateExampleDto): AddExampleResponse {
    const entry = this.exampleService.add(dto);
    return { success: true, entry };
  }

  @Get('list-examples')
  list(): ListExamplesResponse {
    const entries = this.exampleService.list();
    return { entries, count: entries.length };
  }
}
```

### 6. Module (registro)

```typescript
// src/example/example.module.ts
import { Module } from '@nestjs/common';
import { ExampleController } from './example.controller';
import { ExampleService } from './example.service';

@Module({
  controllers: [ExampleController],
  providers: [ExampleService],
})
export class ExampleModule {}
```

### 7. Registrar en AppModule

```typescript
// src/app.module.ts
import { Module } from '@nestjs/common';
import { MoodsModule } from './moods/moods.module';
import { ExampleModule } from './example/example.module';

@Module({
  imports: [MoodsModule, ExampleModule],
})
export class AppModule {}
```

## Convenciones Clave

- Almacenamiento en memoria con arrays (sin ORM ni base de datos)
- IDs generados con `crypto.randomUUID()`
- Timestamps en formato ISO 8601 (`new Date().toISOString()`)
- Listas ordenadas por timestamp descendente
- CORS habilitado globalmente en `main.ts`
- Puerto del servidor: 3000
