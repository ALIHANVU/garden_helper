import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  /// Получает текущую погоду по местоположению пользователя
  Future<Either<Failure, WeatherEntity>> getCurrentWeather();

  /// Получает погоду по заданным координатам
  Future<Either<Failure, WeatherEntity>> getWeatherByCoordinates(double latitude, double longitude);

  /// Получает погоду по названию города
  Future<Either<Failure, WeatherEntity>> getWeatherByCity(String cityName);

  /// Получает прогноз погоды на несколько дней по местоположению пользователя
  Future<Either<Failure, List<DailyForecastEntity>>> getDailyForecast(int days);

  /// Получает прогноз погоды на несколько часов по местоположению пользователя
  Future<Either<Failure, List<HourlyForecastEntity>>> getHourlyForecast(int hours);

  /// Получает рекомендации для садовода на основе текущей погоды
  Future<Either<Failure, GardeningRecommendationEntity>> getGardeningRecommendations();

  /// Проверяет наличие неблагоприятных погодных условий (заморозки, сильный ветер, град и т.д.)
  Future<Either<Failure, bool>> checkForSevereWeatherConditions();

  /// Получает УФ-индекс
  Future<Either<Failure, double>> getUVIndex();

  /// Получает продолжительность светового дня
  Future<Either<Failure, int>> getDaylightDuration();

  /// Получает фазу луны (для лунного календаря садовода)
  Future<Either<Failure, String>> getMoonPhase(DateTime date);
}