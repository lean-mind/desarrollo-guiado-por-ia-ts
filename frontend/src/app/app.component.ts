import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';

interface MoodEntry {
  id: number;
  mood: string;
  note: string;
  timestamp: string;
  date_formatted: string;
  day_of_week: string;
  is_weekend: boolean;
  age_in_seconds: number;
}

interface ListMoodsResponse {
  moods: MoodEntry[];
  count: number;
}

interface AddMoodResponse {
  status: string;
  entry: MoodEntry;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  moods: MoodEntry[] = [];
  validationError = '';
  private apiUrl = 'http://localhost:3000';

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.loadMoods();
  }

  addMood(mood: string, note: string): void {
    if (!mood.trim()) {
      this.validationError = 'El mood no puede estar vacío.';
      return;
    }
    this.validationError = '';

    const data = { mood: mood.trim(), note: note.trim() };

    this.http.post<AddMoodResponse>(`${this.apiUrl}/add`, data).subscribe({
      next: () => {
        this.loadMoods();
      },
      error: (err: unknown) => {
        console.error('Error:', err);
      },
    });
  }

  loadMoods(): void {
    this.http.get<ListMoodsResponse>(`${this.apiUrl}/list`).subscribe({
      next: (response) => {
        this.moods = response.moods;
      },
      error: (err: unknown) => {
        console.error('Error cargando:', err);
        this.moods = [];
      },
    });
  }
}
