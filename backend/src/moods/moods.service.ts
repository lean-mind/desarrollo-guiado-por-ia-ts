import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateMoodDto } from './dto/create-mood.dto';
import { MoodEntry, MoodEntryWithAge } from './dto/mood-entry.dto';
import { AddMoodResponse } from './dto/add-mood-response.dto';
import { ListMoodsResponse } from './dto/list-moods-response.dto';

const DAY_NAMES = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

@Injectable()
export class MoodsService {
  private db: MoodEntry[] = [];

  private formatTimestamp(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    // Python isoformat() gives microseconds; JS only has ms precision.
    // Pad ms * 1000 to 6 digits to match Python's output format.
    const microseconds = String(date.getMilliseconds() * 1000).padStart(6, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}.${microseconds}`;
  }

  private formatDateFormatted(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  addMood(data: CreateMoodDto): AddMoodResponse {
    const now = new Date();
    const entry: MoodEntry = {
      id: this.db.length + 1,
      mood: data.mood ?? 'unknown',
      note: data.note ?? '',
      timestamp: this.formatTimestamp(now),
      date_formatted: this.formatDateFormatted(now),
      day_of_week: DAY_NAMES[now.getDay()],
      // Python: weekday() >= 5 (Mon=0, Sat=5, Sun=6)
      // JS: getDay() === 0 (Sun) || getDay() === 6 (Sat)
      is_weekend: now.getDay() === 0 || now.getDay() === 6,
    };
    this.db.push(entry);
    return { status: 'added', entry };
  }

  getStats(): { total: number; by_mood: Record<string, number> } {
    const by_mood: Record<string, number> = {};
    for (const entry of this.db) {
      by_mood[entry.mood] = (by_mood[entry.mood] ?? 0) + 1;
    }
    return { total: this.db.length, by_mood };
  }

  deleteMood(id: number): { status: string; id: number } {
    const index = this.db.findIndex((m) => m.id === id);
    if (index === -1) throw new NotFoundException(`Mood ${id} not found`);
    this.db.splice(index, 1);
    return { status: 'deleted', id };
  }

  listMoods(): ListMoodsResponse {
    const sorted = [...this.db].sort((a, b) =>
      b.timestamp.localeCompare(a.timestamp),
    );
    const now = Date.now();
    const moods: MoodEntryWithAge[] = sorted.map((item) => ({
      ...item,
      age_in_seconds:
        (now - new Date(item.timestamp).getTime()) / 1000,
    }));
    return { moods, count: moods.length };
  }
}
