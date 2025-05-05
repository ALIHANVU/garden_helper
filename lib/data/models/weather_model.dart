import 'package:garden_helper/domain/entities/weather_entity.dart';

class WeatherModel {
  final double temperature;
  final String condition;
  final double feelsLike;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final String windDirection;
  final double uvIndex;
  final double precipitation;
  final DateTime timestamp;
  final DateTime lastWetDay; // Последний день с осадками
  final List<HourlyForecastModel> hourlyForecast;
  final List<DailyForecastModel> dailyForecast;

  WeatherModel({
    required this.temperature,
    required this.condition,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.precipitation,
    required this.timestamp,
    required this.lastWetDay,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Заглушка для обработки ответа от OpenWeatherMap API
    final main = json['main'] ?? {};
    final weather = json['weather'] != null && json['weather'].isNotEmpty
        ? json['weather'][0]
        : {};
    final wind = json['wind'] ?? {};

    return WeatherModel(
      temperature: (main['temp'] ?? 0.0).toDouble(),
      condition: weather['description'] ?? 'неизвестно',
      feelsLike: (main['feels_like'] ?? 0.0).toDouble(),
      humidity: (main['humidity'] ?? 0.0).toDouble(),
      pressure: (main['pressure'] ?? 0.0).toDouble(),
      windSpeed: (wind['speed'] ?? 0.0).toDouble(),
      windDirection: _getWindDirection(wind['deg'] ?? 0),
      uvIndex: json['uvi'] ?? 0.0,
      precipitation: json['rain'] != null ? (json['rain']['1h'] ?? 0.0).toDouble() : 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      lastWetDay: _getLastWetDay(json),
      hourlyForecast: [], // В реальном приложении будет заполняться из отдельного запроса
      dailyForecast: [], // В реальном приложении будет заполняться из отдельного запроса
    );
  }

  static DateTime _getLastWetDay(Map<String, dynamic> json) {
    // Заглушка, в реальном приложении будет анализ истории осадков
    final timestamp = json['dt'] ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    final rain = json['rain'] != null;

    if (rain) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else {
      // Предположим, что последний дождь был 3 дня назад
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
          .subtract(const Duration(days: 3));
    }
  }

  static String _getWindDirection(int degrees) {
    const directions = [
      'С', 'ССВ', 'СВ', 'ВСВ', 'В', 'ВЮВ', 'ЮВ', 'ЮЮВ',
      'Ю', 'ЮЮЗ', 'ЮЗ', 'ЗЮЗ', 'З', 'ЗСЗ', 'СЗ', 'ССЗ'
    ];
    final index = ((degrees + 11.25) ~/ 22.5) % 16;
    return directions[index];
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      temperature: temperature,
      condition: condition,
      feelsLike: feelsLike,
      humidity: humidity,
      pressure: pressure,
      windSpeed: windSpeed,
      windDirection: windDirection,
      uvIndex: uvIndex,
      precipitation: precipitation,
      timestamp: timestamp,
      hourlyForecast: hourlyForecast.map((model) => model.toEntity()).toList(),
      dailyForecast: dailyForecast.map((model) => model.toEntity()).toList(),
    );
  }
}

class HourlyForecastModel {
  final DateTime time;
  final double temperature;
  final String condition;
  final double precipitation;
  final double windSpeed;

  HourlyForecastModel({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.precipitation,
    required this.windSpeed,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final weather = json['weather'] != null && json['weather'].isNotEmpty
        ? json['weather'][0]
        : {};
    final wind = json['wind'] ?? {};

    return HourlyForecastModel(
      time: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: (main['temp'] ?? 0.0).toDouble(),
      condition: weather['description'] ?? 'неизвестно',
      precipitation: json['rain'] != null ? (json['rain']['3h'] ?? 0.0).toDouble() : 0.0,
      windSpeed: (wind['speed'] ?? 0.0).toDouble(),
    );
  }

  HourlyForecastEntity toEntity() {
    return HourlyForecastEntity(
      time: time,
      temperature: temperature,
      condition: condition,
      precipitation: precipitation,
      windSpeed: windSpeed,
    );
  }
}

class DailyForecastModel {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final String condition;
  final double precipitation;
  final double windSpeed;
  final double humidity;
  final double uvIndex;

  DailyForecastModel({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    required this.precipitation,
    required this.windSpeed,
    required this.humidity,
    required this.uvIndex,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    final temp = json['temp'] ?? {};
    final weather = json['weather'] != null && json['weather'].isNotEmpty
        ? json['weather'][0]
        : {};

    return DailyForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      maxTemperature: (temp['max'] ?? 0.0).toDouble(),
      minTemperature: (temp['min'] ?? 0.0).toDouble(),
      condition: weather['description'] ?? 'неизвестно',
      precipitation: json['rain'] ?? 0.0,
      windSpeed: (json['speed'] ?? 0.0).toDouble(),
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      uvIndex: json['uvi'] ?? 0.0,
    );
  }

  DailyForecastEntity toEntity() {
    return DailyForecastEntity(
      date: date,
      maxTemperature: maxTemperature,
      minTemperature: minTemperature,
      condition: condition,
      precipitation: precipitation,
      windSpeed: windSpeed,
      humidity: humidity,
      uvIndex: uvIndex,
    );
  }
}

class GardeningRecommendationModel {
  final bool isWateringRecommended;
  final bool isPlantingRecommended;
  final bool isPruningRecommended;
  final bool isFertilizingRecommended;
  final bool isHarvestingRecommended;
  final String recommendation;

  GardeningRecommendationModel({
    required this.isWateringRecommended,
    required this.isPlantingRecommended,
    required this.isPruningRecommended,
    required this.isFertilizingRecommended,
    required this.isHarvestingRecommended,
    required this.recommendation,
  });

  GardeningRecommendationEntity toEntity() {
    return GardeningRecommendationEntity(
      isWateringRecommended: isWateringRecommended,
      isPlantingRecommended: isPlantingRecommended,
      isPruningRecommended: isPruningRecommended,
      isFertilizingRecommended: isFertilizingRecommended,
      isHarvestingRecommended: isHarvestingRecommended,
      recommendation: recommendation,
    );
  }
}