import { MoodEntry } from './mood-entry.dto';

export interface AddMoodResponse {
  status: 'added';
  entry: MoodEntry;
}
