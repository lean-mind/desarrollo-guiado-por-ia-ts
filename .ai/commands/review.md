Revisa la implementación del feature indicado.

Feature: $ARGUMENTS

Proceso:
1. Comprueba qué summaries existen en `.ai/workspace/summaries/{feature}/`:
   - Si existe `backend.md` → lanza el agente `backend-architect` en modo revisión
   - Si existe `frontend.md` → lanza el agente `frontend-architect` en modo revisión
2. Lanza en paralelo los agentes correspondientes
3. Cada arquitecto revisará el código de su área y generará su informe en `backend-review.md` o `frontend-review.md`
4. Una vez recibidos los informes, consolida los resultados y emite el veredicto final:
   - APROBADO si todos los arquitectos aprueban
   - APROBADO CON OBSERVACIONES si hay sugerencias no bloqueantes
   - RECHAZADO si algún arquitecto rechaza — detalla qué hay que corregir
