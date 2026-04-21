# Ejercicio 2 — El ciclo de trabajo

## De qué va

Hasta ahora le habéis dado contexto al agente (ejercicio 1). Este ejercicio es sobre el **flujo** en sí: cómo llegar desde una idea vaga hasta código funcionando sin dejar que el agente improvise. Aplica los conceptos de M2.1 (anatomía del prompt) y M2.4 (ciclo de trabajo).

El ciclo completo que vais a practicar:

```
/discovery → PRD → /plan → plan → /execute → summary → /review
```

## Punto de partida

Estáis en la rama `ejercicio-2`, que parte de `solucion-1`. Tenéis todo el contexto del proyecto ya configurado (AGENTS.md, CLAUDE.md, reglas por scope).

Este ejercicio **no trae ejemplos precocinados**: todo el trabajo es aplicar el ciclo, no añadir más estructura al repo.

## Vuestra tarea (obligatoria)

Validar que los moods que se añaden a través del endpoint `/add` del backend no sean vacíos ni superen un límite de caracteres razonable.

Haced el ciclo completo sin saltaros pasos:

1. **`/discovery`** — explorar el problema con el agente. Generar un PRD en `.ai/workspace/prds/` (o equivalente en vuestro setup).
2. **`/plan`** — a partir del PRD, un plan detallado en `.ai/workspace/plans/`. Revisadlo antes de pasar a implementar.
3. **`/execute`** — implementar siguiendo el plan, sin desviarse.
4. **`/review`** — revisar los cambios antes de cerrar.

**Hecho cuando:**
- [ ] Existe un PRD en `.ai/workspace/prds/` (o el directorio equivalente) con el problema descrito.
- [ ] Existe un plan en `.ai/workspace/plans/` con los pasos concretos.
- [ ] La validación del mood vacío está implementada al añadirse por el endpoint `/add`.
- [ ] La validación del mood demasiado largo está implementada al añadirse por el endpoint `/add`.
- [ ] Hay tests que cubren los casos de validación (mood vacío, mood demasiado largo, mood válido).

## Extra (si acabáis antes)

Añadir validación equivalente en el frontend antes de enviar la petición — feedback inmediato al usuario sin necesidad de ida y vuelta al backend.

**Hecho cuando:**
- [ ] El formulario del frontend impide enviar si el mood está vacío o supera el límite.
- [ ] El aviso al usuario se muestra de forma clara.

## Pistas / preguntas mientras trabajáis

- ¿Qué diferencia hay entre empezar con `/plan` directamente y pasar por `/discovery` primero?
- ¿Cuándo es útil revisar el plan antes de ejecutarlo? ¿Qué encontráis que hubieseis implementado mal sin leerlo?
- ¿El agente hizo algo inesperado durante `/execute`? ¿Cómo lo corregisteis?
- ¿Qué regla en `AGENTS.md` o `docs/reglas.md` os habría evitado ese desvío?
- El objetivo no es terminar la feature — es practicar el flujo. Si el discovery tarda más de lo previsto, mejor.

## Referencia

Cuando terminéis, comparad con la rama `solucion-2`:

```bash
git diff ejercicio-2..solucion-2 -- backend/
```
