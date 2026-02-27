# Programming Best Practices — Definición

Definición conceptual de los patrones de diseño utilizados en este proyecto. Para la aplicación específica a cada capa ver los documentos de módulo.

---

## Factory Method

El Factory Method es un patrón creacional que encapsula la construcción de un objeto en un **método estático** de la propia clase, manteniendo el **constructor privado**. Esto garantiza que:

- El objeto solo puede crearse a través del método de factoría.
- Las validaciones se ejecutan **siempre**, sin posibilidad de saltárselas.
- El sitio de llamada recibe o bien un objeto válido, o bien una excepción. Nunca un objeto en estado incoherente.

### Estructura canónica

```typescript
export class MyValueOrEntity {
  private constructor(
    readonly fieldA: string,
    readonly fieldB: number,
  ) {}

  static create(rawA: string, rawB: number): MyValueOrEntity {
    if (!rawA || rawA.trim().length === 0) {
      throw new Error('fieldA is required');
    }
    if (rawB <= 0) {
      throw new Error('fieldB must be positive');
    }
    return new MyValueOrEntity(rawA.trim(), rawB);
  }
}
```

### Propiedades clave

| Propiedad | Razón |
|---|---|
| `private constructor` | Impide instanciar el objeto sin pasar por las validaciones |
| `static create()` | Único punto de entrada; nombre descriptivo del intent |
| Lanza `Error` si inválido | El caller sabe inmediatamente que los datos son incorrectos |
| Devuelve instancia tipada | El tipo en sí mismo certifica que el objeto es válido |

---

## Value Objects

Un Value Object encapsula un valor de dominio junto con sus invariantes. Se diferencia de una entidad en que **no tiene identidad propia**: dos Value Objects con el mismo valor son intercambiables.

Resuelve el problema de "Primitive Obsession": en lugar de pasar `string` sin restricciones por todo el sistema, se pasa un tipo que garantiza que el valor ya fue validado.

### Estructura canónica

```typescript
export class Email {
  private constructor(readonly value: string) {}

  static create(raw: string): Email {
    if (!raw || !raw.includes('@')) {
      throw new Error('invalid email');
    }
    return new Email(raw.toLowerCase().trim());
  }

  equals(other: Email): boolean {
    return this.value === other.value;
  }

  toString(): string {
    return this.value;
  }
}
```

### Propiedades clave

| Propiedad | Razón |
|---|---|
| `private constructor` | Solo se crea a través de `create()`, que valida |
| Inmutabilidad (`readonly`) | El valor no cambia después de crearse |
| `equals()` por valor | La identidad es el valor, no la referencia de objeto |
| `toString()` | Facilita la serialización sin exponer el campo directamente |

---

## Repository Pattern

El Repository Pattern introduce una interfaz entre el dominio y el mecanismo de persistencia (o cualquier fuente de datos externa). El dominio define **qué necesita** (la interfaz); la infraestructura decide **cómo obtenerlo** (la implementación).

### Estructura canónica

```typescript
// Puerto secundario — definido en el dominio
export interface ItemRepository {
  save(item: Item): Item;
  findById(id: number): Item | undefined;
  findAll(): Item[];
}

// Token de inyección (NestJS / Angular)
export const ITEM_REPOSITORY = Symbol('ItemRepository');

// Adaptador secundario — definido en infraestructura
@Injectable()
export class InMemoryItemRepository implements ItemRepository {
  private items: Item[] = [];

  save(item: Item): Item {
    this.items.push(item);
    return item;
  }

  findById(id: number): Item | undefined {
    return this.items.find(i => i.id === id);
  }

  findAll(): Item[] {
    return [...this.items];
  }
}
```

### Propiedades clave

| Propiedad | Razón |
|---|---|
| Interfaz en el dominio | El dominio no depende de ninguna implementación concreta |
| Implementación en infraestructura | Sustituible sin tocar el dominio ni el servicio |
| Devuelve copias (`[...this.items]`) | Evita mutaciones accidentales desde el exterior |
| Token de inyección (`Symbol`) | Desacopla la DI del tipo concreto |
