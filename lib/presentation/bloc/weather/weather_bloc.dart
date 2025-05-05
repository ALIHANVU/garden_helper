import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/weather_entity.dart';
import 'package:garden_helper/domain/usecases/weather/get_current_weather_usecase.dart';

// Events
abstract class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadWeatherEvent extends WeatherEvent {}

class LoadWeatherByCityEvent extends WeatherEvent {
  final String city;

  LoadWeatherByCityEvent({required this.city});

  @override
  List<Object> get props => [city];
}

class LoadWeatherByCoordinatesEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  LoadWeatherByCoordinatesEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class RefreshWeatherEvent extends WeatherEvent {}

// States
abstract class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;
  final GardeningRecommendationEntity recommendations;

  WeatherLoaded({
    required this.weather,
    required this.recommendations,
  });

  @override
  List<Object> get props => [weather, recommendations];
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;

  WeatherBloc({
    required this.getCurrentWeatherUseCase,
  }) : super(WeatherInitial()) {
    on<LoadWeatherEvent>(_onLoadWeather);
    on<LoadWeatherByCityEvent>(_onLoadWeatherByCity);
    on<LoadWeatherByCoordinatesEvent>(_onLoadWeatherByCoordinates);
    on<RefreshWeatherEvent>(_onRefreshWeather);
  }

  Future<void> _onLoadWeather(LoadWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    final result = await getCurrentWeatherUseCase(const NoParams());
    result.fold(
          (failure) => emit(WeatherError(message: _mapFailureToMessage(failure))),
          (weather) {
        // В реальном приложении здесь будет вызов usecase для получения рекомендаций
        // Заглушка для демонстрации:
        final recommendations = GardeningRecommendationEntity(
          isWateringRecommended: true,
          isPlantingRecommended: true,
          isPruningRecommended: true,
          isFertilizingRecommended: false,
          isHarvestingRecommended: false,
          recommendation: 'Отличный день для полива и посадки растений!',
        );

        emit(WeatherLoaded(
          weather: weather,
          recommendations: recommendations,
        ));
      },
    );
  }

  Future<void> _onLoadWeatherByCity(LoadWeatherByCityEvent event, Emitter<WeatherState> emit) async {
    // Реализовать загрузку погоды по городу
  }

  Future<void> _onLoadWeatherByCoordinates(
      LoadWeatherByCoordinatesEvent event, Emitter<WeatherState> emit) async {
    // Реализовать загрузку погоды по координатам
  }

  Future<void> _onRefreshWeather(RefreshWeatherEvent event, Emitter<WeatherState> emit) async {
    add(LoadWeatherEvent());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Ошибка сервера погоды: ${failure.message}';
      case ConnectionFailure:
        return 'Ошибка подключения: ${failure.message}';
      case TimeoutFailure:
        return 'Превышено время ожидания: ${failure.message}';
      case ApiFailure:
        return 'Ошибка API погоды: ${failure.message}';
      default:
        return 'Неожиданная ошибка: ${failure.message}';
    }
  }
}