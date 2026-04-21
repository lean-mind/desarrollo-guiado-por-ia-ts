# Ejercicio 3 — Comandos

## De qué va

Los comandos personalizados convierten secuencias de trabajo repetidas en instrucciones reutilizables que el equipo comparte. Este ejercicio aplica lo aprendido en M2.5 (comandos): diseñar el comando `/execute` que el equipo usará para implementar cambios a partir de un plan previo.

## Punto de partida

Estáis en la rama `ejercicio-3`, que parte de `solucion-2` con dos comandos ya escritos y el script de sincronización listo.

### Ya hecho en esta rama (ejemplos)

- `.ai/commands/discovery.md` — comando para explorar el problema a fondo antes de escribir código.
- `.ai/commands/plan.md` — comando para crear un plan de implementación detallado sin ejecutar nada.
- `scripts/sync-ai.sh` — script que enlaza `.ai/commands/` a `.claude/commands/`, `.cursor/commands/` y `.opencode/commands/`.
- `.ai/workspace/` — directorio de trabajo para documentos de discovery, planes y resúmenes.

Leed los dos comandos antes de empezar — definen el patrón: instrucción de rol + proceso + formato de salida.

## Vuestra tarea (obligatoria)

Escribir el comando `/execute` y sincronizarlo para que esté disponible en Claude Code.

**Hecho cuando:**
- [ ] Existe `.ai/commands/execute.md` con: qué input espera (plan de implementación), qué outputs produce (cambios en el código + resumen) y qué restricciones tiene (p.ej. "implementa exactamente lo que indica el plan; si hay ambigüedad, pregunta antes").
- [ ] Tras ejecutar `bash scripts/sync-ai.sh`, el comando aparece disponible en `.claude/commands/execute.md`.
- [ ] Al invocar `/execute` con un plan en el contexto, el agente implementa los cambios sin desviarse del plan.

## Extra (si acabáis antes)

1. Escribir `.ai/commands/review.md` — comando para revisar los cambios implementados y generar un resumen.
2. Probar `/execute` contra un caso real: extraer el CSS inline del componente principal del frontend a un fichero separado.

**Hecho cuando:**
- [ ] Existe `.ai/commands/review.md` con criterios de revisión explícitos.
- [ ] El refactor CSS se completó usando `/execute` sin intervención manual adicional.

## Pistas / preguntas mientras trabajáis

- Comparad `discovery.md` y `plan.md`: ¿qué tienen en común en cuanto a estructura? ¿cómo limita cada uno el ámbito del agente?
- ¿Qué instrucción añadiríais a `/execute` para que el agente no improvise más allá del plan?
- ¿El agente usó el comando de forma distinta a lo que escribisteis? ¿Por qué crees que pasó?
- ¿Cuándo necesitáis `/plan` antes de `/execute`? ¿Cuándo podéis ir directo a `/execute`?

## Referencia

Cuando terminéis, comparad con la rama `solucion-3`:

```bash
git diff ejercicio-3..solucion-3 -- .ai/commands/execute.md
```
