import { Module } from '@nestjs/common';
import { MoodsModule } from './moods/moods.module';

@Module({
  imports: [MoodsModule],
})
export class AppModule {}
