import 'dart:convert';
import 'package:garden_helper/core/error/exceptions.dart';
import 'package:garden_helper/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRemoteDataSource {
  /// Получает текущую погоду по местоположению пользователя
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<WeatherModel> getCurrentWeather();

  /// Получает погоду по заданным координатам
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<WeatherModel> getWeatherByCoordinates(double latitude, double longitude);

  /// Получает погоду по названию города
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<WeatherModel> getWeatherByCity(String cityName);

  /// Получает прогноз погоды на несколько дней
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<List<DailyForecastModel>> getDailyForecast(double latitude, double longitude, int days);

  /// Получает прогноз погоды на несколько часов
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<List<HourlyForecastModel>> getHourlyForecast(double latitude, double longitude, int hours);

  /// Получает рекомендации для садовода на основе текущей погоды
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<GardeningRecommendationModel> getGardeningRecommendations(double latitude, double longitude);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  // В реальном приложении ключ должен храниться в безопасном месте, например, в .env файле
  final String apiKey = 'c708426913319b328c4ff4719583d1c6';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather() async {
    // Заглушка, в реальном приложении здесь будет получение координат устройства
    return getWeatherByCoordinates(55.7558, 37.6173); // Москва
  }

  @override
  Future<WeatherModel> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey&lang=ru'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
          message: 'Ошибка при получении погоды',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }

  @override
  Future<WeatherModel> getWeatherByCity(String cityName) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/weather?q=$cityName&units=metric&appid=$apiKey&lang=ru'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Город не найден');
      } else {
        throw ServerException(
          message: 'Ошибка при получении погоды',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is NotFoundException) {
        rethrow;
      }
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<DailyForecastModel>> getDailyForecast(double latitude, double longitude, int days) async {
    try {
      // Note: OpenWeatherMap API изменился, теперь для дневного прогноза используется другой эндпоинт
      final response = await client.get(
        Uri.parse('$baseUrl/forecast/daily?lat=$latitude&lon=$longitude&cnt=$days&units=metric&appid=$apiKey&lang=ru'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['list'];
        return jsonList.map((json) => DailyForecastModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Ошибка при получении прогноза погоды',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<HourlyForecastModel>> getHourlyForecast(double latitude, double longitude, int hours) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/forecast?lat=$latitude&lon=$longitude&units=metric&cnt=${hours ~/ 3}&appid=$apiKey&lang=ru'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['list'];
        return jsonList.map((json) => HourlyForecastModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Ошибка при получении почасового прогноза',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }

  @override
  Future<GardeningRecommendationModel> getGardeningRecommendations(double latitude, double longitude) async {
    try {
      // В реальном приложении здесь будет запрос к специализированному API или расчет рекомендаций
      // на основе погодных данных и характеристик растений пользователя

      // Получаем погоду для формирования рекомендаций
      final weather = await getWeatherByCoordinates(latitude, longitude);

      return GardeningRecommendationModel(
        isWateringRecommended: weather.precipitation < 1.0 && weather.temperature > 15,
        isPlantingRecommended: weather.temperature > 10 && weather.temperature < 25 && weather.precipitation < 5.0,
        isPruningRecommended: weather.temperature > 15 && weather.precipitation < 1.0,
        isFertilizingRecommended: weather.temperature > 18 && weather.precipitation < 2.0,
        isHarvestingRecommended: weather.temperature > 20 && weather.precipitation < 1.0,
        recommendation: _generateRecommendation(weather),
      );
    } catch (e) {
      throw ServerException(
        message: 'Ошибка при получении рекомендаций: ${e.toString()}',
      );
    }
  }

  String _generateRecommendation(WeatherModel weather) {
    if (weather.temperature < 10) {
      return 'Сегодня холодно для большинства садовых работ. Лучше заняться планированием.';
    } else if (weather.precipitation > 5) {
      return 'Ожидаются сильные осадки. Избегайте работ в саду и защитите уязвимые растения.';
    } else if (weather.temperature > 25) {
      return 'Сегодня жарко. Рекомендуется полив растений рано утром или вечером, избегайте пересадки и обрезки.';
    } else if (weather.precipitation < 1 && DateTime.now().difference(weather.lastWetDay).inDays > 3) {
      return 'Сухая погода продолжается более 3 дней. Обязательно полейте растения, особенно недавно посаженные.';
    } else {
      return 'Отличный день для садовых работ! Можно заняться посадкой, прополкой и уходом за растениями.';
    }
  }
}