Revisa los cambios actuales y evalúa su calidad.

Proceso:
1. Ejecuta `git diff HEAD` para ver todos los cambios pendientes
2. Lee los ficheros AGENTS.md y docs/ relevantes para conocer las reglas del proyecto
3. Evalúa los cambios en estas dimensiones:
   - **Corrección**: ¿los cambios hacen lo que se espera?
   - **Reglas**: ¿respetan las convenciones definidas en AGENTS.md y docs/?
   - **Tests**: ¿los cambios tienen cobertura de tests suficiente?
   - **Seguridad**: ¿se introducen vulnerabilidades o se exponen datos sensibles?

Formato de salida:
- ✓ Puntos positivos
- ✗ Problemas a corregir (con fichero y línea)
- ⚠ Sugerencias opcionales de mejora
