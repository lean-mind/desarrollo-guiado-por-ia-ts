# Ejercicio 1 — Contexto del proyecto

## De qué va

Cuando un agente llega al repo por primera vez, no sabe qué es el proyecto, cómo está estructurado ni qué reglas debe seguir. Este ejercicio aplica los conceptos del módulo 2 (gestión de contexto, reglas ejecutables): añadir los ficheros que le dan esa información al agente antes de que escriba una sola línea de código.

## Punto de partida

Estáis en la rama `ejercicio-1`, que parte de `main` con los ficheros de contexto ya creados para la raíz y el backend NestJS.

### Ya hecho en esta rama (ejemplos)

- `AGENTS.md` — descripción del proyecto, stack y estructura global.
- `CLAUDE.md` — puntero a `@AGENTS.md` para Claude Code.
- `docs/commits.md` — convenciones de commits (Conventional Commits adaptados).
- `backend/AGENTS.md` — contexto específico del backend NestJS: endpoints, arquitectura, comandos.
- `backend/CLAUDE.md` — puntero a `@AGENTS.md` en el scope de backend.
- `backend/docs/reglas.md` — reglas ejecutables del backend (tests, linter, convenciones de código).

Leed estos ficheros antes de empezar — son la plantilla que debéis seguir.

## Vuestra tarea (obligatoria)

Crear el contexto equivalente para el frontend Angular.

**Hecho cuando:**
- [ ] Existe `frontend/AGENTS.md` con el stack (Angular), estructura de carpetas, cómo arrancar y cómo testear.
- [ ] Existe `frontend/CLAUDE.md` que apunta a `@AGENTS.md`.
- [ ] Existe `frontend/docs/reglas.md` con al menos 3 reglas ejecutables específicas del frontend.
- [ ] Al preguntar al agente dentro de `frontend/` ("¿qué convenciones sigue este proyecto?"), responde de forma coherente con esas reglas.

## Extra (si acabáis antes)

Añadir una regla ejecutable al backend que el agente pueda verificar con un test. Por ejemplo: "todos los endpoints nuevos requieren al menos un test de integración con `@nestjs/testing`".

**Hecho cuando:**
- [ ] La regla está en `backend/docs/reglas.md` con un criterio verificable que el agente pueda comprobar ejecutando `npm test`.

## Pistas / preguntas mientras trabajáis

- Comparad `backend/AGENTS.md` con `AGENTS.md` raíz: ¿qué información se repite? ¿qué es específico del scope?
- ¿Qué reglas del frontend son ejecutables (el agente puede verificar si se cumplen) y cuáles son solo estilo?
- ¿Qué le diríais al agente sobre los componentes standalone? ¿Y sobre signals vs RxJS?
- ¿Qué pasa si el agente ve información contradictoria entre el `AGENTS.md` raíz y el del frontend?
- ¿Qué dejarías fuera para no generar ruido?

## Referencia

Cuando terminéis, comparad con la rama `solucion-1`:

```bash
git diff ejercicio-1..solucion-1 -- frontend/
```
