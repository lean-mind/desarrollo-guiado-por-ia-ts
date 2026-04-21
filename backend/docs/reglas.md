# Reglas del backend — NestJS

## Validación de input

✓ Usar DTOs tipados con `class-validator` para todo body de endpoint.
✗ Nunca aceptar `@Body() data: any` ni `@Body() data: object`.

```typescript
// ✓ Correcto
@Post('add')
addMood(@Body() data: CreateMoodDto): AddMoodResponse { ... }

// ✗ Incorrecto
@Post('add')
addMood(@Body() data: any): any { ... }
```

## Separación de responsabilidades

✓ La lógica de negocio va en el servicio (`moods.service.ts`).
✗ No implementar lógica ni acceder al estado desde el controlador.

```typescript
// ✓ Correcto: el controlador delega al servicio
@Post('add')
addMood(@Body() data: CreateMoodDto): AddMoodResponse {
  return this.moodsService.addMood(data);
}

// ✗ Incorrecto: lógica en el controlador
@Post('add')
addMood(@Body() data: CreateMoodDto) {
  const entry = { id: this.db.length + 1, ...data };
  this.db.push(entry);
  return entry;
}
```

## Tipado

✓ Definir interfaces o tipos en `dto/` para todo valor retornado.
✗ No retornar `any` desde ningún método de servicio o controlador.

## Tests

✓ Cada método público del servicio tiene su test unitario en `*.spec.ts`.
✗ No usar el servidor de desarrollo como única verificación del comportamiento.
