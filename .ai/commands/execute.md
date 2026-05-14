Ejecuta los planes aprobados del feature indicado.

Feature: $ARGUMENTS

Proceso:
1. Comprueba que planes existen en `.ai/workspace/plans/{feature}/`:
   - Si existe `backend.md`, lanza `backend-dev`.
   - Si existe `frontend.md`, lanza `frontend-dev`.
2. Lanza en paralelo los agentes correspondientes.
3. Cada dev implementa su plan siguiendo TDD, marcando items del checklist y commiteando.
4. Los summaries se generan en `.ai/workspace/summaries/{feature}/backend.md` o `frontend.md`.
