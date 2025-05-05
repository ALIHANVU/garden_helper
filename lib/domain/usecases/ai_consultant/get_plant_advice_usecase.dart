import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';
import 'package:garden_helper/domain/repositories/ai_consultant_repository.dart';

class GetPlantAdviceUseCase implements UseCase<AIConsultationEntity, PlantAdviceParams> {
  final AIConsultantRepository repository;

  GetPlantAdviceUseCase(this.repository);

  @override
  Future<Either<Failure, AIConsultationEntity>> call(PlantAdviceParams params) async {
    return await repository.getPlantAdvice(params.query);
  }
}

class PlantAdviceParams extends Equatable {
  final String query;

  const PlantAdviceParams({
    required this.query,
  });

  @override
  List<Object> get props => [query];
}