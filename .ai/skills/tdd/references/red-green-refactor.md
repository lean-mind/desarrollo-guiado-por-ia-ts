# Red-Green-Refactor: Ejemplos en TypeScript/Jest

## Ejemplo: endpoint DELETE /moods/:id

### Red — test que falla

```typescript
it('should delete a mood by id', async () => {
  const created = await service.addMood({ mood: 'happy' });
  const result = await service.deleteMood(created.entry.id);
  expect(result).toEqual({ status: 'deleted', id: created.entry.id });
});
```

Ejecuta: `npm test` → **FAIL** (método `deleteMood` no existe)

### Green — código mínimo

```typescript
deleteMood(id: number): { status: string; id: number } {
  this.db = this.db.filter(m => m.id !== id);
  return { status: 'deleted', id };
}
```

Ejecuta: `npm test` → **PASS**

### Refactor — mejoras sin cambiar comportamiento

```typescript
deleteMood(id: number): DeleteMoodResponse {
  const index = this.db.findIndex(m => m.id === id);
  if (index === -1) throw new NotFoundException(`Mood ${id} not found`);
  this.db.splice(index, 1);
  return { status: 'deleted', id };
}
```

Ejecuta: `npm test` → **PASS** (añadir test para 404 en siguiente ciclo)

## Anti-patrones a evitar

| Anti-patrón | Correcto |
|-------------|----------|
| Escribir 5 tests antes del código | Un test → código → siguiente test |
| Test que pasa sin haber escrito código | El test debe fallar primero |
| Refactor que añade funcionalidad | Refactor solo mejora estructura |
| Skip del refactor | Siempre refactorizar antes del commit |
