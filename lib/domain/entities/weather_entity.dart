import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
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
  final List<HourlyForecastEntity> hourlyForecast;
  final List<DailyForecastEntity> dailyForecast;

  const WeatherEntity({
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
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  @override
  List<Object?> get props => [
    temperature,
    condition,
    feelsLike,
    humidity,
    pressure,
    windSpeed,
    windDirection,
    uvIndex,
    precipitation,
    timestamp,
    hourlyForecast,
    dailyForecast,
  ];
}

class HourlyForecastEntity extends Equatable {
  final DateTime time;
  final double temperature;
  final String condition;
  final double precipitation;
  final double windSpeed;

  const HourlyForecastEntity({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.precipitation,
    required this.windSpeed,
  });

  @override
  List<Object?> get props => [
    time,
    temperature,
    condition,
    precipitation,
    windSpeed,
  ];
}

class DailyForecastEntity extends Equatable {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final String condition;
  final double precipitation;
  final double windSpeed;
  final double humidity;
  final double uvIndex;

  const DailyForecastEntity({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    required this.precipitation,
    required this.windSpeed,
    required this.humidity,
    required this.uvIndex,
  });

  @override
  List<Object?> get props => [
    date,
    maxTemperature,
    minTemperature,
    condition,
    precipitation,
    windSpeed,
    humidity,
    uvIndex,
  ];
}

class GardeningRecommendationEntity extends Equatable {
  final bool isWateringRecommended;
  final bool isPlantingRecommended;
  final bool isPruningRecommended;
  final bool isFertilizingRecommended;
  final bool isHarvestingRecommended;
  final String recommendation;

  const GardeningRecommendationEntity({
    required this.isWateringRecommended,
    required this.isPlantingRecommended,
    required this.isPruningRecommended,
    required this.isFertilizingRecommended,
    required this.isHarvestingRecommended,
    required this.recommendation,
  });

  @override
  List<Object?> get props => [
    isWateringRecommended,
    isPlantingRecommended,
    isPruningRecommended,
    isFertilizingRecommended,
    isHarvestingRecommended,
    recommendation,
  ];
}