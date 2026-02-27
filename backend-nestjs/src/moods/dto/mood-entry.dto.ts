export interface MoodEntry {
  id: number;
  mood: string;
  note: string;
  timestamp: string;
  date_formatted: string;
  day_of_week: string;
  is_weekend: boolean;
}

export interface MoodEntryWithAge extends MoodEntry {
  age_in_seconds: number;
}
