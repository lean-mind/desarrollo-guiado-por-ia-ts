Ejecuta el plan de implementación paso a paso.

Plan: $ARGUMENTS

Proceso:
1. Lee el plan en `.ai/workspace/plans/$ARGUMENTS`
2. Para cada paso del plan:
   a. Implementa el cambio mínimo necesario
   b. Ejecuta los tests y verifica que pasan
   c. Si un test falla, diagnostica y corrige antes de continuar
   d. Indica explícitamente cuando el paso está completado
3. No avances al siguiente paso sin completar el actual
4. Si encuentras algo inesperado que no estaba en el plan, detente y explica el problema

Al finalizar, genera un summary con:
- Objetivo que se implementó
- Cambios realizados por fichero
- Tests añadidos o modificados
- Decisiones tomadas que no estaban en el plan (si las hubo)

Guarda el summary en `.ai/workspace/summaries/` con el mismo nombre que el plan.
