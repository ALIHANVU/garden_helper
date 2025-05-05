import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/exceptions.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/network/network_info.dart';
import 'package:garden_helper/data/datasources/remote/ai_consultant_remote_datasource.dart';
import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';
import 'package:garden_helper/domain/repositories/ai_consultant_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIConsultantRepositoryImpl implements AIConsultantRepository {
  final AIConsultantRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  // Ключи для SharedPreferences
  static const String premiumKey = 'premium_user';
  static const String premiumExpiryKey = 'premium_expiry';

  AIConsultantRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, AIConsultationEntity>> getPlantAdvice(String query) async {
    // Проверяем доступность премиум-функций
    final premiumResult = await isPremiumAvailable();

    if (premiumResult.isLeft()) {
      return Left(premiumResult.fold(
            (f) => f,
            (_) => const SubscriptionFailure(message: 'Ошибка проверки премиум-статуса'),
      ));
    }

    final isPremium = premiumResult.getOrElse(() => false);
    if (!isPremium) {
      return Left(SubscriptionFailure(
        message: 'Для использования ИИ-консультанта необходима премиум-подписка',
      ));
    }

    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getPlantAdvice(query);
        return Right(response.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(message: 'Нет подключения к интернету'));
    }
  }

  @override
  Future<Either<Failure, AIConsultationEntity>> identifyPlantByImage(String base64Image) async {
    // Проверяем доступность премиум-функций
    final premiumResult = await isPremiumAvailable();

    if (premiumResult.isLeft()) {
      return Left(premiumResult.fold(
            (f) => f,
            (_) => const SubscriptionFailure(message: 'Ошибка проверки премиум-статуса'),
      ));
    }

    final isPremium = premiumResult.getOrElse(() => false);
    if (!isPremium) {
      return Left(SubscriptionFailure(
        message: 'Для использования ИИ-консультанта необходима премиум-подписка',
      ));
    }

    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.identifyPlantByImage(base64Image);
        return Right(response.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(message: 'Нет подключения к интернету'));
    }
  }

  @override
  Future<Either<Failure, AIConsultationEntity>> getDiagnosis(String plantDescription, String symptomsDescription) async {
    // Проверяем доступность премиум-функций
    final premiumResult = await isPremiumAvailable();

    if (premiumResult.isLeft()) {
      return Left(premiumResult.fold(
            (f) => f,
            (_) => const SubscriptionFailure(message: 'Ошибка проверки премиум-статуса'),
      ));
    }

    final isPremium = premiumResult.getOrElse(() => false);
    if (!isPremium) {
      return Left(SubscriptionFailure(
        message: 'Для использования ИИ-консультанта необходима премиум-подписка',
      ));
    }

    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getDiagnosis(plantDescription, symptomsDescription);
        return Right(response.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(message: 'Нет подключения к интернету'));
    }
  }

  @override
  Future<Either<Failure, bool>> isPremiumAvailable() async {
    try {
      final isPremium = sharedPreferences.getBool(premiumKey) ?? false;

      if (!isPremium) {
        return const Right(false);
      }

      final expiryString = sharedPreferences.getString(premiumExpiryKey);
      if (expiryString == null) {
        return const Right(false);
      }

      final expiryDate = DateTime.parse(expiryString);
      final now = DateTime.now();

      if (now.isAfter(expiryDate)) {
        // Подписка истекла, обновляем статус
        await sharedPreferences.setBool(premiumKey, false);
        return const Right(false);
      }

      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: 'Ошибка при проверке премиум-статуса: ${e.toString()}'));
    }
  }
}