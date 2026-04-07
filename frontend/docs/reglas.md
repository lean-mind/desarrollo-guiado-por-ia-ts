# Reglas del frontend — Angular

## Tipado

✓ Definir interfaces TypeScript para todos los modelos de datos recibidos de la API.
✗ Nunca usar `any` en tipos, parámetros ni variables.

```typescript
// ✓ Correcto
interface MoodEntry {
  id: number;
  mood: string;
  note: string;
  date_formatted: string;
  day_of_week: string;
}

moods: MoodEntry[] = [];
addMood(mood: string, note: string): void { ... }

// ✗ Incorrecto
moods: any = [];
addMood(mood: any, note: any) { ... }
```

## Estilos

✓ Los estilos van en ficheros `.css` separados, referenciados desde `styleUrls`.
✗ No usar `styles: [...]` inline en el decorador `@Component`.

```typescript
// ✓ Correcto
@Component({
  styleUrls: ['./app.component.css'],
  ...
})

// ✗ Incorrecto
@Component({
  styles: [`div { background: magenta; font-family: Comic Sans MS; }`],
  ...
})
```

## Componentes

✓ Los componentes son standalone (con `standalone: true`).
✗ No añadir componentes a `declarations` de un NgModule.
