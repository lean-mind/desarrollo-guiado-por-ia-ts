# Arquitectura Hexagonal — Backend

> Definición conceptual: [docs/hexagonal-architecture.md](../../docs/hexagonal-architecture.md)

El backend implementa los conceptos de arquitectura hexagonal de forma implícita. Este documento mapea cada capa del patrón a los archivos existentes.

---

## Mapeo al código

### 1. Dominio (núcleo)

| Concepto | Archivo | Descripción |
|---|---|---|
| Entidad de dominio | `src/moods/dto/mood-entry.dto.ts` | Define `MoodEntry` y `MoodEntryWithAge` — la forma canónica del dato |
| Lógica de negocio | `src/moods/moods.service.ts` | Construye entradas con timestamp, `day_of_week`, `is_weekend`; ordena el listado por fecha descendente |

El servicio **no depende de HTTP ni de ningún framework de persistencia**. Solo conoce datos y reglas.

### 2. Puertos

> **Estado actual:** los puertos no están definidos como interfaces TypeScript explícitas. El servicio actúa como puerto primario de forma implícita a través de sus métodos públicos.

| Puerto | Tipo | Representado por |
|---|---|---|
| `addMood(dto)` | Primario (entrada) | Método público en `MoodsService` |
| `listMoods()` | Primario (entrada) | Método público en `MoodsService` |
| Almacenamiento | Secundario (salida) | `private db: MoodEntry[]` — array en memoria en `MoodsService` |

### 3. Adaptadores

| Adaptador | Archivo | Dirección |
|---|---|---|
| HTTP REST (entrada) | `src/moods/moods.controller.ts` | Exterior → Dominio |
| In-memory store (salida) | Array `db` en `moods.service.ts` | Dominio → Almacenamiento |
| Bootstrap + CORS | `src/main.ts` | Infraestructura de entrada |

El controlador no contiene lógica: recibe la petición HTTP, delega al servicio, y devuelve la respuesta. Es un adaptador puro.

---

## Diagrama

```
                   ┌─────────────────────────────┐
  HTTP Request ───>│  Adaptador primario          │
  POST /add        │  moods.controller.ts         │
  GET /list        │                              │
                   └──────────────┬───────────────┘
                                  │ llama a
                   ┌──────────────▼───────────────┐
                   │  DOMINIO                      │
                   │  moods.service.ts             │
                   │                               │
                   │  addMood()  listMoods()       │
                   └──────────────┬───────────────┘
                                  │ lee/escribe
                   ┌──────────────▼───────────────┐
                   │  Adaptador secundario         │
                   │  db: MoodEntry[]  (memoria)   │
                   └───────────────────────────────┘
```

---

## DTOs como contrato de puertos

Los DTOs en `src/moods/dto/` definen el contrato de cada puerto:

| DTO | Puerto que define |
|---|---|
| `CreateMoodDto` | Entrada del puerto `addMood` |
| `AddMoodResponse` | Salida del puerto `addMood` |
| `ListMoodsResponse` | Salida del puerto `listMoods` |
| `MoodEntry` / `MoodEntryWithAge` | Entidad de dominio compartida |

---

## Deuda arquitectónica

| Problema | Impacto | Solución futura |
|---|---|---|
| El adaptador de almacenamiento está embebido en el servicio | El dominio no puede cambiar de persistencia sin modificar `MoodsService` | Extraer una interfaz `MoodRepository` y un adaptador `InMemoryMoodRepository` |
| No hay interfaz explícita para `MoodsService` | El controlador acopla al tipo concreto | Definir una interfaz `IMoodsService` como puerto primario |
| Datos en memoria | Reiniciar la app borra todos los moods | Implementar un adaptador de base de datos real |
