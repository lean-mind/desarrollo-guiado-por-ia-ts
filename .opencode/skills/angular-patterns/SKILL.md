---
name: angular-patterns
description: Patrones y convenciones de Angular 21 usados en el proyecto Mood Tracker. Carga este skill cuando necesites crear componentes, servicios o configurar routing siguiendo la arquitectura existente.
---

## Arquitectura Standalone de Angular 21

El proyecto usa la arquitectura standalone moderna de Angular (sin NgModules).

## Bootstrap

```typescript
// src/main.ts
import { bootstrapApplication } from '@angular/platform-browser';
import { provideHttpClient } from '@angular/common/http';
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, {
  providers: [
    provideHttpClient(),
    // Agregar mas providers aqui (routing, etc.)
  ],
});
```

## Crear un Componente Standalone

```typescript
// src/app/example/example.component.ts
import { Component, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';

interface ExampleEntry {
  id: string;
  name: string;
  value: number;
  timestamp: string;
}

@Component({
  selector: 'app-example',
  standalone: true,
  template: `
    <div class="container">
      <h2>Example</h2>

      @if (loading()) {
        <p>Cargando...</p>
      }

      @for (item of items(); track item.id) {
        <div class="item">
          <span>{{ item.name }}</span>
          <span>{{ item.value }}</span>
        </div>
      } @empty {
        <p>No hay elementos</p>
      }
    </div>
  `,
  styles: `
    .container {
      padding: 1rem;
    }
    .item {
      display: flex;
      justify-content: space-between;
      padding: 0.5rem;
      border-bottom: 1px solid #eee;
    }
  `
})
export class ExampleComponent {
  private http = inject(HttpClient);
  private apiUrl = 'http://localhost:3000';

  items = signal<ExampleEntry[]>([]);
  loading = signal(false);

  constructor() {
    this.loadItems();
  }

  loadItems() {
    this.loading.set(true);
    this.http.get<{ entries: ExampleEntry[] }>(`${this.apiUrl}/list-examples`)
      .subscribe({
        next: (response) => {
          this.items.set(response.entries);
          this.loading.set(false);
        },
        error: (err) => {
          console.error('Error loading items:', err);
          this.loading.set(false);
        }
      });
  }

  addItem(name: string, value: number) {
    this.http.post<{ success: boolean; entry: ExampleEntry }>(
      `${this.apiUrl}/add-example`,
      { name, value }
    ).subscribe({
      next: (response) => {
        if (response.success) {
          this.loadItems(); // Recargar la lista
        }
      },
      error: (err) => console.error('Error adding item:', err)
    });
  }
}
```

## Crear un Servicio

```typescript
// src/app/services/example.service.ts
import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class ExampleService {
  private http = inject(HttpClient);
  private apiUrl = 'http://localhost:3000';

  getAll() {
    return this.http.get<{ entries: any[] }>(`${this.apiUrl}/list-examples`);
  }

  create(data: { name: string; value: number }) {
    return this.http.post(`${this.apiUrl}/add-example`, data);
  }
}
```

## Convenciones Clave

- Todos los componentes son `standalone: true`
- Usar `inject()` en lugar de inyeccion por constructor
- Usar `signal()` para estado reactivo local del componente
- Usar el nuevo control flow: `@if`, `@for`, `@switch` (no `*ngIf`, `*ngFor`)
- Track expression obligatoria en `@for` (ej: `track item.id`)
- HttpClient ya esta provisto globalmente en `main.ts`
- Backend URL: `http://localhost:3000`
- Templates y estilos inline para componentes simples
- Templates y estilos en archivos separados para componentes complejos
- No usar NgModules para nada
