import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/weather_entity.dart';
import 'package:garden_helper/domain/repositories/weather_repository.dart';

class GetCurrentWeatherUseCase implements UseCase<WeatherEntity, NoParams> {
  final WeatherRepository repository;

  GetCurrentWeatherUseCase(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(NoParams params) async {
    return await repository.getCurrentWeather();
  }
}