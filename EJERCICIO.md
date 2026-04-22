# Ejercicio 5 — Skills y MCPs

## De qué va

Los comandos encapsulan flujos de trabajo; las skills encapsulan conocimiento de proceso. Este ejercicio aplica los conceptos de M3.2 (MCP) y M3.3 (skills): enseñar al agente a trabajar con TDD creando la skill que describe el ciclo Red-Green-Refactor.

## Punto de partida

Estáis en la rama `ejercicio-5`, que parte de `solucion-4`. El MCP ya está configurado y tenéis una skill de ejemplo completa (Conventional Commits) para usar como plantilla.

### Ya hecho en esta rama (ejemplos)

- `.ai/skills/commit/SKILL.md` — skill de Conventional Commits: define cuándo activarla, el formato esperado y ejemplos. Es el patrón que debéis seguir.
- `.ai/mcp.json` — configuración de servidores MCP.
- `scripts/sync-ai.sh` — actualizado para sincronizar skills y MCP a `.claude/`, `.cursor/` y `.opencode/`.
- `.env.example` — variables de entorno necesarias para los MCP.

Leed `SKILL.md` antes de empezar — define la estructura: cuándo activarse, proceso y formato de salida.

## Referencia rápida: TDD (Red-Green-Refactor)

TDD (Test-Driven Development) es un ciclo de tres pasos que se repite por cada unidad de comportamiento:

1. **Red** — escribe un test que describe el comportamiento esperado. Ejecútalo: debe fallar porque el código aún no existe.
2. **Green** — escribe el código mínimo necesario para que el test pase. Sin más.
3. **Refactor** — mejora el código sin cambiar su comportamiento. Los tests deben seguir pasando.

La regla clave: nunca escribas código de producción sin un test rojo previo.

## Vuestra tarea (obligatoria)

Escribir la skill de TDD para que el agente siga el ciclo Red-Green-Refactor al implementar.

**Hecho cuando:**
- [ ] Existe `.ai/skills/tdd/SKILL.md` con instrucciones claras: cuándo activar la skill y cómo aplicar el ciclo.
- [ ] Existe `.ai/skills/tdd/references/red-green-refactor.md` con el ciclo explicado en detalle para consultarlo.
- [ ] `bash scripts/sync-ai.sh` sincroniza la skill a `.claude/skills/`.
- [ ] Al pedirle al agente implementar algo con TDD, sigue el ciclo sin que se lo recordéis en cada paso.

## Extra (si acabáis antes)

Implementar el endpoint `DELETE /delete/:id` aplicando la skill TDD recién escrita: primero el test rojo, luego la implementación mínima.

**Hecho cuando:**
- [ ] El test del endpoint DELETE falla antes de implementar la lógica.
- [ ] El endpoint funciona y `npm test` pasa sin errores.

## Pistas / preguntas mientras trabajáis

- Comparad vuestra skill TDD con la skill de commit precocinada: ¿qué nivel de detalle es suficiente? ¿cuánto es demasiado?
- ¿Cuándo debe "activarse" la skill? ¿La ponéis siempre activa o solo cuando el agente va a implementar?
- ¿El agente siguió el ciclo Red-Green-Refactor sin recordatorios, o tuvisteis que corregirlo?
- ¿Qué parte del ciclo tiende a saltarse el agente? ¿Por qué crees que es eso?
- ¿Qué MCP añadisteis y por qué? ¿Compensó el coste de contexto adicional?

## Referencia

Cuando terminéis, comparad con la rama `solucion-5`:

```bash
git diff ejercicio-5..solucion-5 -- .ai/skills/tdd/
```
