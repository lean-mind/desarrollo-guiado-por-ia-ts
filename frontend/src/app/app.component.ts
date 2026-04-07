import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div style="background-color: #ff00ff; padding: 20px; border: 5px solid red;">
      <h1 style="color: yellow; text-shadow: 2px 2px red; font-family: Comic Sans MS;">MOOD TRACKER 3000</h1>
      
      <div style="background: cyan; border: 3px dashed lime; padding: 10px; margin: 10px;">
        <h3 style="color: red;">Agregar Mood</h3>
        <input 
          #moodInput
          type="text" 
          placeholder="Como te sientes?" 
          style="background: yellow; border: 2px solid red; color: blue; font-size: 20px;"
        >
        <br><br>
        <textarea 
          #noteInput
          placeholder="Notas..." 
          style="background: lime; border: 2px solid purple; width: 300px; height: 100px;"
        ></textarea>
        <br><br>
        <button 
          (click)="addMood(moodInput.value, noteInput.value)"
          style="background: orange; color: white; border: 4px solid black; padding: 15px; font-weight: bold;"
        >
          GUARDAR MOOD!
        </button>
      </div>

      <div style="background: yellow; border: 5px solid blue; padding: 15px; margin-top: 20px;">
        <h2 style="color: red; text-decoration: underline;">Historial de Moods</h2>
        <button 
          (click)="loadMoods()"
          style="background: red; color: yellow; border: 3px solid green; margin-bottom: 10px;"
        >
          ACTUALIZAR LISTA
        </button>
        
        <div *ngFor="let item of moods" style="background: pink; border: 2px solid green; margin: 5px; padding: 10px;">
          <p style="color: blue; font-size: 18px;"><strong>Mood:</strong> {{item.mood}}</p>
          <p style="color: purple;"><strong>Nota:</strong> {{item.note}}</p>
          <p style="color: orange; font-size: 12px;">{{item.date_formatted}} - {{item.day_of_week}}</p>
        </div>
      </div>
    </div>
  `,
  styles: [``]
})
export class AppComponent {
  moods: any = [];
  private apiUrl = 'http://localhost:3000';

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.loadMoods();
  }

  addMood(mood: any, note: any) {
    const data: any = {
      mood: mood,
      note: note
    };
    
    this.http.post(`${this.apiUrl}/add`, data).subscribe({
      next: (response: any) => {
        console.log('Guardado:', response);
        this.loadMoods();
      },
      error: (err: any) => {
        console.error('Error:', err);
        alert('ERROR AL GUARDAR!');
      }
    });
  }

  loadMoods() {
    this.http.get(`${this.apiUrl}/list`).subscribe({
      next: (response: any) => {
        this.moods = response.moods || [];
        console.log('Moods cargados:', this.moods);
      },
      error: (err: any) => {
        console.error('Error cargando:', err);
        this.moods = [];
      }
    });
  }
}
