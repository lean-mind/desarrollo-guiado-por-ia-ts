import { IsOptional, IsString, MaxLength } from 'class-validator';

export class CreateMoodDto {
  @IsOptional()
  @IsString()
  @MaxLength(100)
  mood?: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  note?: string;
}
