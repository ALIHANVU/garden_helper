import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/plant_entity.dart';
import 'package:garden_helper/domain/repositories/plant_repository.dart';

class WaterPlantUseCase implements UseCase<PlantEntity, WaterPlantParams> {
  final PlantRepository repository;

  WaterPlantUseCase(this.repository);

  @override
  Future<Either<Failure, PlantEntity>> call(WaterPlantParams params) async {
    return await repository.waterPlant(params.plantId, params.date);
  }
}

class WaterPlantParams extends Equatable {
  final String plantId;
  final DateTime date;

  const WaterPlantParams({
    required this.plantId,
    required this.date,
  });

  @override
  List<Object> get props => [plantId, date];
}