import { Controller, Post, Get, Delete, Body, Param, ParseIntPipe } from '@nestjs/common';
import { MoodsService } from './moods.service';
import { CreateMoodDto } from './dto/create-mood.dto';
import { AddMoodResponse } from './dto/add-mood-response.dto';
import { ListMoodsResponse } from './dto/list-moods-response.dto';

@Controller()
export class MoodsController {
  constructor(private readonly moodsService: MoodsService) {}

  @Post('add')
  addMood(@Body() data: CreateMoodDto): AddMoodResponse {
    return this.moodsService.addMood(data);
  }

  @Get('list')
  listMoods(): ListMoodsResponse {
    return this.moodsService.listMoods();
  }

  @Delete('delete/:id')
  deleteMood(@Param('id', ParseIntPipe) id: number): { status: string; id: number } {
    return this.moodsService.deleteMood(id);
  }
}
