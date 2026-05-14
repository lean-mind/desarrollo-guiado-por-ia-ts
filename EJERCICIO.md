# Showcase multiagente — Fan-in/Fan-out

Esta rama es una demo del formador. Parte de `solucion-6` y extiende el pipeline portable con agentes especializados por area.

## Flujo

1. `/discovery {tema}` lanza `debater` y genera un PRD sin detalles de implementacion.
2. `/plan {feature}` decide si el cambio afecta a backend, frontend o ambos.
3. El plan hace fan-out a `backend-architect` y/o `frontend-architect`.
4. `/execute {feature}` lanza `backend-dev` y/o `frontend-dev` en paralelo.
5. `/review {feature}` vuelve a los arquitectos para revisar cada area y consolidar el veredicto.

## Que demuestra

- Un agente logico no es un fichero de una herramienta: se define en `.ai/agents/*.yaml` y `.ai/agents/prompts/`.
- El generador crea adaptadores para Claude, Codex, OpenCode y Cursor en `.ai/generated/`.
- El contexto se divide por area y rol: arquitectos planifican/revisan; devs implementan.
- El orquestador humano conserva los puntos de decision: aprobar planes, lanzar ejecucion y aceptar/rechazar la revision.

## Comandos utiles

```bash
scripts/generate-agents --dry-run --platform claude --agent backend-architect
scripts/generate-agents --dry-run --platform codex --agent backend-dev
scripts/generate-agents --check
scripts/sync-ai.sh --dry-run --platform all
```
