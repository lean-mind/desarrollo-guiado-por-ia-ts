import 'reflect-metadata';
import { MoodsService } from './moods.service';

describe('MoodsService', () => {
  let service: MoodsService;

  beforeEach(() => {
    service = new MoodsService();
  });

  describe('addMood', () => {
    it('should return status "added" with the new entry', () => {
      const result = service.addMood({ mood: 'happy', note: 'great day' });

      expect(result.status).toBe('added');
      expect(result.entry.mood).toBe('happy');
      expect(result.entry.note).toBe('great day');
    });

    it('should default mood to "unknown" when not provided', () => {
      const result = service.addMood({});

      expect(result.entry.mood).toBe('unknown');
    });

    it('should default note to empty string when not provided', () => {
      const result = service.addMood({ mood: 'ok' });

      expect(result.entry.note).toBe('');
    });

    it('should assign incrementing ids', () => {
      const first = service.addMood({ mood: 'happy' });
      const second = service.addMood({ mood: 'sad' });

      expect(second.entry.id).toBe(first.entry.id + 1);
    });

    it('should include timestamp, date_formatted and day_of_week', () => {
      const result = service.addMood({ mood: 'ok' });

      expect(result.entry.timestamp).toBeDefined();
      expect(result.entry.date_formatted).toMatch(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/);
      expect(result.entry.day_of_week).toBeDefined();
    });

    it('should set is_weekend correctly for the current date', () => {
      const result = service.addMood({ mood: 'ok' });
      const today = new Date();
      const expectedIsWeekend = today.getDay() === 0 || today.getDay() === 6;

      expect(result.entry.is_weekend).toBe(expectedIsWeekend);
    });
  });

  describe('listMoods', () => {
    it('should return empty list when no moods have been added', () => {
      const result = service.listMoods();

      expect(result.moods).toHaveLength(0);
      expect(result.count).toBe(0);
    });

    it('should return all added moods with count', () => {
      service.addMood({ mood: 'happy' });
      service.addMood({ mood: 'sad' });

      const result = service.listMoods();

      expect(result.moods).toHaveLength(2);
      expect(result.count).toBe(2);
    });

    it('should include age_in_seconds for each entry', () => {
      service.addMood({ mood: 'happy' });

      const result = service.listMoods();

      expect(result.moods[0].age_in_seconds).toBeGreaterThanOrEqual(0);
    });

    it('should return moods sorted by timestamp descending', async () => {
      service.addMood({ mood: 'first' });
      await new Promise((resolve) => setTimeout(resolve, 10));
      service.addMood({ mood: 'second' });

      const result = service.listMoods();

      expect(result.moods[0].mood).toBe('second');
      expect(result.moods[1].mood).toBe('first');
    });
  });
});
