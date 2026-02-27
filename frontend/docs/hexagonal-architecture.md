# Arquitectura Hexagonal — Frontend

> Definición conceptual: [docs/hexagonal-architecture.md](../../docs/hexagonal-architecture.md)

El frontend es una Single Page Application Angular con un único componente standalone. Este documento mapea los conceptos de arquitectura hexagonal a la estructura existente.

---

## Mapeo al código

### 1. Dominio (núcleo)

| Concepto | Archivo | Descripción |
|---|---|---|
| Modelo de dominio | Tipo implícito `any[]` en `app.component.ts:45` | Lista de moods sin tipado explícito |
| Lógica de presentación | `app.component.ts` — métodos `addMood()` y `loadMoods()` | Coordinan la obtención y envío de datos |

> **Estado actual:** no existe un modelo de dominio explícito. El componente usa `moods: any[]`, lo que elimina la distinción entre dominio y adaptador.

### 2. Puertos

> **Estado actual:** los puertos no están definidos como interfaces TypeScript explícitas.

| Puerto | Tipo | Representado por |
|---|---|---|
| Cargar moods | Primario (entrada desde template) | `loadMoods()` llamado en `ngOnInit` |
| Agregar mood | Primario (entrada desde template) | `addMood(mood, note)` disparado por el botón |
| HTTP GET /list | Secundario (salida hacia API) | `HttpClient.get()` en `loadMoods()` |
| HTTP POST /add | Secundario (salida hacia API) | `HttpClient.post()` en `addMood()` |

### 3. Adaptadores

| Adaptador | Ubicación | Dirección |
|---|---|---|
| Template HTML | Inline en `app.component.ts` | Usuario → Dominio (inputs, click) |
| `HttpClient` | Inyectado en `app.component.ts` | Dominio → API REST |
| `provideHttpClient()` | `src/main.ts` | Infraestructura de comunicación |

---

## Diagrama

```
  Usuario              ┌─────────────────────────────┐
  (click, input) ─────>│  Adaptador primario          │
                        │  Template inline             │
                        │  app.component.ts            │
                        └──────────────┬──────────────┘
                                       │ llama a
                        ┌─────────────▼──────────────┐
                        │  DOMINIO                    │
                        │  addMood() / loadMoods()    │
                        │  moods: any[]               │
                        └──────────────┬──────────────┘
                                       │ delega a
                        ┌─────────────▼──────────────┐
                        │  Adaptador secundario        │
                        │  HttpClient                 │
                        │  → POST /add                │
                        │  → GET /list                │
                        └─────────────────────────────┘
                                       │
                                  Backend API
                                  :3000 (actual)
                                  :8000 (hardcoded)
```

---

## Contrato con el backend

El frontend consume los campos definidos en `MoodEntry` directamente en el template:

| Campo consumido | Línea en template | Origen en backend |
|---|---|---|
| `item.mood` | `app.component.ts:46` | `MoodEntry.mood` |
| `item.note` | `app.component.ts:47` | `MoodEntry.note` |
| `item.date_formatted` | `app.component.ts:48` | `MoodEntry.date_formatted` |
| `item.day_of_week` | `app.component.ts:48` | `MoodEntry.day_of_week` |

Cualquier cambio en los DTOs del backend debe reflejarse aquí manualmente.

---

## Deuda arquitectónica

| Problema | Impacto | Solución futura |
|---|---|---|
| `moods: any[]` sin tipo | No hay validación en compilación; el template puede romperse silenciosamente | Definir una interfaz `MoodEntry` local que refleje el contrato del backend |
| Dominio, adaptador HTTP y template en un solo archivo | Imposible testear la lógica sin el DOM | Separar en un servicio `MoodService` (adaptador HTTP) y mantener el componente solo como presentación |
| `apiUrl` hardcodeado a `http://localhost:8000` | El frontend no conecta al backend sin modificar el código | Usar `environment.ts` o un token de inyección para la URL base |
| Sin manejo de errores estructurado | Los errores solo disparan `alert()` | Implementar un manejo de estado de error en el componente |
