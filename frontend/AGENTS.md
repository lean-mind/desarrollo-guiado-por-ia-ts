# Frontend — Angular

Aplicación Angular standalone que consume la API del backend NestJS.

## Arquitectura

Un único componente standalone `AppComponent` en `src/app/app.component.ts`.

- **API URL:** `http://localhost:3000` (backend NestJS)
- **Puerto de desarrollo:** `http://localhost:4200`

## Reglas

Ver `docs/reglas.md` para las convenciones del frontend.

## Comandos

```bash
npm start           # Servidor de desarrollo (http://localhost:4200)
npm run build       # Build de producción en dist/
npm test            # Ejecutar tests
```
