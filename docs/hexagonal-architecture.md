# Arquitectura Hexagonal — Definición

La arquitectura hexagonal (también llamada Ports & Adapters) organiza el código en tres capas concéntricas. El objetivo es que el núcleo de negocio no dependa de ningún framework, base de datos, protocolo HTTP ni librería externa.

---

## Las tres capas

### 1. Dominio (núcleo)

Contiene la lógica de negocio pura. No importa nada de frameworks ni infraestructura. Es la capa más estable del sistema: cambia solo cuando cambian las reglas de negocio.

Incluye:
- Entidades y Value Objects
- Servicios de dominio
- Interfaces de repositorio (definición, no implementación)

### 2. Puertos

Los puertos son las interfaces que definen cómo se comunica el dominio con el exterior. Existen dos tipos:

| Tipo | Dirección | Propósito |
|---|---|---|
| **Puerto primario** (driving) | Exterior → Dominio | Define cómo el mundo exterior invoca al dominio (API de casos de uso) |
| **Puerto secundario** (driven) | Dominio → Exterior | Define cómo el dominio accede a infraestructura (persistencia, mensajería, etc.) |

Los puertos son **interfaces TypeScript**, no implementaciones. El dominio solo conoce la interfaz; nunca la implementación concreta.

### 3. Adaptadores

Los adaptadores implementan los puertos. Traducen entre el protocolo externo y el lenguaje del dominio.

| Tipo | Ejemplos |
|---|---|
| **Adaptador primario** | Controlador HTTP, CLI, handler de cola de mensajes |
| **Adaptador secundario** | Repositorio en memoria, repositorio PostgreSQL, cliente de API externa |

Un adaptador concreto puede ser reemplazado por otro sin tocar ninguna línea del dominio.

---

## Diagrama genérico

```
  [ Exterior: HTTP / CLI / Tests ]
              │
              ▼
  ┌─────────────────────────┐
  │  Adaptador primario     │  ← traduce el protocolo externo al dominio
  └────────────┬────────────┘
               │  Puerto primario (interfaz)
               ▼
  ┌─────────────────────────┐
  │        DOMINIO          │  ← sin dependencias externas
  │  entidades, servicios,  │
  │  interfaces de puerto   │
  └────────────┬────────────┘
               │  Puerto secundario (interfaz)
               ▼
  ┌─────────────────────────┐
  │  Adaptador secundario   │  ← implementa acceso a infraestructura
  └─────────────────────────┘
              │
              ▼
  [ Infraestructura: DB / API / Memoria ]
```

---

## Regla de dependencia

Las dependencias apuntan **siempre hacia el interior**:

- Los adaptadores dependen de los puertos (interfaces del dominio).
- El dominio no depende de nada externo.
- Si el dominio necesita algo del exterior, lo define como una interfaz (puerto secundario) y delega la implementación a un adaptador.
