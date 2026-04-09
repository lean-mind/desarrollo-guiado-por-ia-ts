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
  this.db = this.db.filter(m => m.id !== id);
  return { status: 'deleted', id };
}
```

Cambios: tipar el retorno con `DeleteMoodResponse` en vez de un objeto literal.
El comportamiento externo es idéntico — mismos inputs producen mismos outputs.

Ejecuta: `npm test` → **PASS**

## Anti-patrones a evitar

| Anti-patrón | Correcto |
|-------------|----------|
| Escribir 5 tests antes del código | Un test → código → siguiente test |
| Test que pasa sin haber escrito código | El test debe fallar primero |
| Refactor que añade funcionalidad | Refactor solo mejora estructura |
| Skip del refactor | Siempre refactorizar antes del commit |
