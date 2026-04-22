# Ejercicio 6 — Agentes especializados

## De qué va

Un único agente generalista acumula contexto de todo el proyecto y tiende a improvisar. Este ejercicio aplica los conceptos de M4.1 (anatomía del agente) y M4.2 (contextos efímeros): definir agentes con roles acotados y herramientas restringidas para formar un pipeline planner → executor → reviewer.

El planner y el reviewer ya están escritos — vuestra tarea es completar el pipeline con el executor.

## Punto de partida

Estáis en la rama `ejercicio-6`, que parte de `solucion-5`. Los agentes de solo lectura están precocinados. El comando `/execute` ya apunta al executor, pero el executor aún no existe.

### Ya hecho en esta rama (ejemplos)

- `.ai/agents/planner.md` — agente que lee un PRD y genera un plan en checklist. Solo tiene acceso a Read, Glob y Grep.
- `.ai/agents/reviewer.md` — agente que revisa la implementación contra el plan y las reglas. Solo lectura.
- `AGENTS.md` — actualizado con la sección "Agentes especializados" y el patrón de orquestación.
- `.ai/commands/{discovery,plan,execute,review}.md` — actualizados para delegar en los agentes.

Leed los dos agentes precocinados antes de empezar — definen el patrón: nombre, descripción, herramientas y rol.

## Vuestra tarea (obligatoria)

Escribir `.ai/agents/executor.md` y usar el pipeline completo para implementar el endpoint `GET /stats` (número total de moods registrados + breakdown por fecha).

**Hecho cuando:**
- [ ] Existe `.ai/agents/executor.md` con rol claro, herramientas de lectura y escritura, y la instrucción de seguir TDD.
- [ ] El endpoint `GET /stats` está implementado con tests que cubren los casos básicos.
- [ ] Hay un summary en `.ai/workspace/summaries/` que evidencia el uso del pipeline (planner generó el plan, executor lo implementó, reviewer lo validó).

## Extra (si acabáis antes)

Añadir `.ai/agents/debater.md` — un agente con método socrático que analiza el problema con preguntas antes de generar un PRD. Actualizar `/discovery` para que lo invoque.

**Hecho cuando:**
- [ ] Existe `.ai/agents/debater.md` con instrucciones de método socrático.
- [ ] Al invocar `/discovery`, el debater hace preguntas antes de escribir el PRD.

## Pistas / preguntas mientras trabajáis

- Comparad el planner y el reviewer: ¿qué herramientas tiene cada uno? ¿Por qué esa restricción?
- ¿Qué herramientas le daríais al executor que no le daríais al planner? ¿Cuáles nunca debería tener?
- ¿El reviewer encontró algo que vosotros no habíais visto?
- ¿En qué casos vale la pena el overhead del pipeline? ¿Cuándo iríais directo al agente generalista?
- ¿Qué pasaría si el executor pudiera modificar el plan mientras lo ejecuta?

## Referencia

Cuando terminéis, comparad con la rama `solucion-6`:

```bash
git diff ejercicio-6..solucion-6 -- .ai/agents/executor.md backend/
```
