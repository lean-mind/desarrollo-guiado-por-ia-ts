---
description: Ejecuta los tests del frontend y reporta fallos
agent: angular-dev
---

Ejecuta los tests del frontend con el siguiente comando desde el directorio `frontend/`:

!`cd frontend && npm test 2>&1 || true`

Analiza los resultados:
- Si todos los tests pasan, reporta un resumen
- Si hay fallos, identifica cada test fallido, explica la causa y sugiere una correccion
- Si no hay tests configurados, indica como configurar testing con Angular

$ARGUMENTS
