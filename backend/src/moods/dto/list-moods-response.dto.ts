import { MoodEntryWithAge } from './mood-entry.dto';

export interface ListMoodsResponse {
  moods: MoodEntryWithAge[];
  count: number;
}
