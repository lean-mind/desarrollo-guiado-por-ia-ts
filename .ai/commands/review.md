Revisa la implementacion del feature indicado.

Feature: $ARGUMENTS

Proceso:
1. Comprueba que summaries existen en `.ai/workspace/summaries/{feature}/`:
   - Si existe `backend.md`, lanza `backend-architect` en modo revision.
   - Si existe `frontend.md`, lanza `frontend-architect` en modo revision.
2. Lanza en paralelo los agentes correspondientes.
3. Cada arquitecto revisa el codigo de su area y genera `backend-review.md` o `frontend-review.md`.
4. Consolida los resultados y emite veredicto final:
   - APROBADO si todos los arquitectos aprueban.
   - APROBADO CON OBSERVACIONES si hay sugerencias no bloqueantes.
   - RECHAZADO si algun arquitecto rechaza, detallando que hay que corregir.
