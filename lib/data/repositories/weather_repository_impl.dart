import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/exceptions.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/network/network_info.dart';
import 'package:garden_helper/data/datasources/remote/weather_remote_datasource.dart';
import 'package:garden_helper/domain/entities/weather_entity.dart';
import 'package:garden_helper/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather() async {
    return _getWeather(() => remoteDataSource.getCurrentWeather());
  }

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherByCoordinates(
      double latitude, double longitude) async {
    return _getWeather(() => remoteDataSource.getWeatherByCoordinates(latitude, longitude));
  }

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherByCity(String cityName) async {
    return _getWeather(() => remoteDataSource.getWeatherByCity(cityName));
  }

  Future<Either<Failure, WeatherEntity>> _getWeather(
      Future<dynamic> Function() getWeather) async {
    if (await networkInfo.isConnected) {
      try {
        final weatherModel = await getWeather();
        return Right(weatherModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(message: 'Нет подключения к интернету'));
    }
  }

  @override
  Future<Either<Failure, List<DailyForecastEntity>>> getDailyForecast(int days) async {
    if (await networkInfo.isConnected) {
      try {
        // Заглушка координат для Москвы
        final forecastModels = await remoteDataSource.getDailyForecast(55.7558, 37.6173, days);
        return Right(forecastModels.map((model) => model.toEntity()).toList());
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
  Future<Either<Failure, List<HourlyForecastEntity>>> getHourlyForecast(int hours) async {
    if (await networkInfo.isConnected) {
      try {
        // Заглушка координат для Москвы
        final forecastModels = await remoteDataSource.getHourlyForecast(55.7558, 37.6173, hours);
        return Right(forecastModels.map((model) => model.toEntity()).toList());
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
  Future<Either<Failure, GardeningRecommendationEntity>> getGardeningRecommendations() async {
    if (await networkInfo.isConnected) {
      try {
        // Заглушка координат для Москвы
        final recommendationModel = await remoteDataSource.getGardeningRecommendations(55.7558, 37.6173);
        return Right(recommendationModel.toEntity());
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
  Future<Either<Failure, bool>> checkForSevereWeatherConditions() async {
    // В этой версии не реализовано
    return const Right(false);
  }

  @override
  Future<Either<Failure, double>> getUVIndex() async {
    // В этой версии не реализовано
    return const Right(0.0);
  }

  @override
  Future<Either<Failure, int>> getDaylightDuration() async {
    // В этой версии не реализовано
    return const Right(12 * 60); // 12 часов в минутах
  }

  @override
  Future<Either<Failure, String>> getMoonPhase(DateTime date) async {
    // В этой версии не реализовано
    return const Right('Не определено');
  }
}