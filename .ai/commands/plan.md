Lee el PRD indicado y decide qué agentes arquitectos lanzar.

PRD: $ARGUMENTS

Proceso:
1. Lee el PRD en `.ai/workspace/prds/` (o el path completo si se indica)
2. Determina si el cambio afecta al backend, al frontend o a ambos
3. Lanza en paralelo los agentes correspondientes:
   - Si afecta al backend → lanza el agente `backend-architect` con el PRD
   - Si afecta al frontend → lanza el agente `frontend-architect` con el PRD
4. Cada arquitecto generará su plan en `.ai/workspace/plans/{feature}/backend.md` o `frontend.md`
5. Presenta los planes al usuario y **espera aprobación explícita antes de continuar**
