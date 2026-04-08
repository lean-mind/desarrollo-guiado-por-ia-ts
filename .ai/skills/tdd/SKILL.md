# Skill: TDD (Test-Driven Development)

Implementa cualquier cambio siguiendo el ciclo Red-Green-Refactor. No escribas código de producción sin un test fallando primero.

## Ciclo obligatorio

```
Red    → Escribe un test que falle (describe el comportamiento esperado)
Green  → Escribe el mínimo código para que el test pase
Refactor → Mejora el código sin cambiar el comportamiento (los tests siguen pasando)
```

## Reglas

- Un test a la vez. No escribas múltiples tests antes de hacer que el primero pase.
- El test debe fallar por la razón correcta (no por error de compilación o import).
- En la fase Green: el código más simple posible, aunque sea hardcodeado.
- En Refactor: elimina duplicación, mejora nombres, extrae funciones — pero no añadas funcionalidad nueva.
- Commit al final de cada ciclo completo (un ciclo = un test verde + refactor).

## Cómo aplicar esta skill

Antes de cada implementación, di en voz alta:
1. "¿Qué comportamiento quiero probar?"
2. Escribe el test → ejecuta → confirma que falla en rojo
3. Escribe el código mínimo → ejecuta → confirma verde
4. Refactoriza → ejecuta → confirma que sigue verde

## Referencias

Ver `references/red-green-refactor.md` para ejemplos concretos en TypeScript/Jest.
