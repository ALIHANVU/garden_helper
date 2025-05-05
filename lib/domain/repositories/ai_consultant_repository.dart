import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';

abstract class AIConsultantRepository {
  /// Получает совет по уходу за растением
  Future<Either<Failure, AIConsultationEntity>> getPlantAdvice(String query);

  /// Идентифицирует растение по изображению
  Future<Either<Failure, AIConsultationEntity>> identifyPlantByImage(String base64Image);

  /// Получает диагноз проблемы растения
  Future<Either<Failure, AIConsultationEntity>> getDiagnosis(String plantDescription, String symptomsDescription);

  /// Проверяет доступность премиум-функций
  Future<Either<Failure, bool>> isPremiumAvailable();
}