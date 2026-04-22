# Skill: Conventional Commits

Escribe mensajes de commit siguiendo el estándar Conventional Commits. Cada commit debe describir un cambio atómico y comprensible.

## Formato

```
<tipo>(<scope opcional>): <descripción en imperativo, minúsculas>

[cuerpo opcional: qué y por qué, no cómo]
```

## Tipos

| Tipo | Cuándo usarlo |
|------|--------------|
| `feat` | Nueva funcionalidad visible para el usuario |
| `fix` | Corrección de un bug |
| `test` | Añadir o corregir tests |
| `refactor` | Cambio que no añade funcionalidad ni corrige bug |
| `chore` | Tareas de mantenimiento (deps, config, build) |
| `docs` | Solo documentación |

## Ejemplos

```
# ✓ Correcto
feat(moods): añadir endpoint DELETE /moods/:id
fix(validation): retornar 422 cuando mood supera 100 caracteres
test(moods): cubrir casos de id inexistente en delete
refactor(moods): extraer lógica de fecha a función pura

# ✗ Incorrecto
fix: stuff
Update code
feat: added the new delete endpoint for moods that was requested
WIP
```

## Reglas

- Imperativo presente: "añadir", no "añadido" ni "añade"
- Minúsculas: "feat(moods): añadir..." no "Feat(moods): Añadir..."
- Sin punto final en la descripción
- Scope = módulo afectado (moods, auth, frontend, etc.)
- Un commit = un cambio lógico (no mezcles feat + refactor)
