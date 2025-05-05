import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/plant_entity.dart';
import 'package:garden_helper/domain/repositories/plant_repository.dart';

class GetPlantsNeedingWaterUseCase implements UseCase<List<PlantEntity>, NoParams> {
  final PlantRepository repository;

  GetPlantsNeedingWaterUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlantEntity>>> call(NoParams params) async {
    return await repository.getPlantsNeedingWater();
  }
}