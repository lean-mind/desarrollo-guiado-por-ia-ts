# Frontend — Angular

Aplicación Angular standalone que consume la API del backend NestJS.

## Arquitectura

Un único componente standalone `AppComponent` en `src/app/app.component.ts`.

- **API URL:** `http://localhost:3000` (backend NestJS)
- **Puerto de desarrollo:** `http://localhost:4200`

## Reglas

✓ Definir interfaces TypeScript para todos los modelos de datos recibidos de la API.
✗ Nunca usar `any` en tipos, parámetros ni variables.

✓ Los estilos van en ficheros `.css` separados, referenciados desde `styleUrls`.
✗ No usar `styles: [...]` inline en el decorador `@Component`.

✓ Los componentes son standalone (sin NgModules).
✗ No añadir componentes a `declarations` de un NgModule.

## Comandos

```bash
npm start           # Servidor de desarrollo (http://localhost:4200)
npm run build       # Build de producción en dist/
npm test            # Ejecutar tests
```
