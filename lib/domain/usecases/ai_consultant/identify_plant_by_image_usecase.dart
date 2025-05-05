import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';
import 'package:garden_helper/domain/repositories/ai_consultant_repository.dart';

class IdentifyPlantByImageUseCase implements UseCase<AIConsultationEntity, ImageParams> {
  final AIConsultantRepository repository;

  IdentifyPlantByImageUseCase(this.repository);

  @override
  Future<Either<Failure, AIConsultationEntity>> call(ImageParams params) async {
    return await repository.identifyPlantByImage(params.base64Image);
  }
}

class ImageParams extends Equatable {
  final String base64Image;

  const ImageParams({
    required this.base64Image,
  });

  @override
  List<Object> get props => [base64Image];
}