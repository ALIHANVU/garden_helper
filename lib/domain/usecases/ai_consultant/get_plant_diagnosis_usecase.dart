import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';
import 'package:garden_helper/domain/repositories/ai_consultant_repository.dart';

class GetPlantDiagnosisUseCase implements UseCase<AIConsultationEntity, DiagnosisParams> {
  final AIConsultantRepository repository;

  GetPlantDiagnosisUseCase(this.repository);

  @override
  Future<Either<Failure, AIConsultationEntity>> call(DiagnosisParams params) async {
    return await repository.getDiagnosis(params.plantDescription, params.symptomsDescription);
  }
}

class DiagnosisParams extends Equatable {
  final String plantDescription;
  final String symptomsDescription;

  const DiagnosisParams({
    required this.plantDescription,
    required this.symptomsDescription,
  });

  @override
  List<Object> get props => [plantDescription, symptomsDescription];
}