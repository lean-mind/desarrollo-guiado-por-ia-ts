# Convenciones de commits

Seguimos el formato [Conventional Commits](https://www.conventionalcommits.org/).

## Formato

```
<tipo>(<scope>): <descripción en imperativo>
```

## Tipos

| Tipo | Cuándo usarlo |
|------|--------------|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `test` | Añadir o modificar tests |
| `refactor` | Cambio de código sin añadir funcionalidad ni corregir bug |
| `chore` | Mantenimiento: dependencias, configuración, scripts |
| `docs` | Cambios exclusivamente en documentación |

## Ejemplos

✓ `feat(moods): add DELETE /moods/:id endpoint`
✓ `fix(frontend): correct API base URL port to 3000`
✓ `test(moods): add unit tests for MoodsService.listMoods`
✓ `refactor(frontend): extract mood list to standalone component`
✓ `chore: add ESLint configuration`

✗ `update stuff`
✗ `WIP`
✗ `fixed bug`
✗ `cambios varios`
