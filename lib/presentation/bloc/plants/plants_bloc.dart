import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/usecases/usecase.dart';
import 'package:garden_helper/domain/entities/plant_entity.dart';
import 'package:garden_helper/domain/usecases/plant/get_all_plants_usecase.dart';
import 'package:garden_helper/domain/usecases/plant/get_plants_needing_water_usecase.dart';
import 'package:garden_helper/domain/usecases/plant/water_plant_usecase.dart';

// Events
abstract class PlantsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPlantsEvent extends PlantsEvent {}

class LoadPlantsNeedingWaterEvent extends PlantsEvent {}

class WaterPlantEvent extends PlantsEvent {
  final String plantId;

  WaterPlantEvent({required this.plantId});

  @override
  List<Object> get props => [plantId];
}

class FilterPlantsByCategoryEvent extends PlantsEvent {
  final PlantCategory category;

  FilterPlantsByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class SearchPlantsEvent extends PlantsEvent {
  final String query;

  SearchPlantsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class ToggleFavoritePlantEvent extends PlantsEvent {
  final String plantId;

  ToggleFavoritePlantEvent({required this.plantId});

  @override
  List<Object> get props => [plantId];
}

// States
abstract class PlantsState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlantsInitial extends PlantsState {}

class PlantsLoading extends PlantsState {}

class PlantsLoaded extends PlantsState {
  final List<PlantEntity> plants;

  PlantsLoaded({required this.plants});

  @override
  List<Object> get props => [plants];
}

class PlantsError extends PlantsState {
  final String message;

  PlantsError({required this.message});

  @override
  List<Object> get props => [message];
}

class PlantWatered extends PlantsState {
  final PlantEntity plant;

  PlantWatered({required this.plant});

  @override
  List<Object> get props => [plant];
}

// Bloc
class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  final GetAllPlantsUseCase getAllPlantsUseCase;
  final GetPlantsNeedingWaterUseCase getPlantsNeedingWaterUseCase;
  final WaterPlantUseCase waterPlantUseCase;

  PlantsBloc({
    required this.getAllPlantsUseCase,
    required this.getPlantsNeedingWaterUseCase,
    required this.waterPlantUseCase,
  }) : super(PlantsInitial()) {
    on<LoadPlantsEvent>(_onLoadPlants);
    on<LoadPlantsNeedingWaterEvent>(_onLoadPlantsNeedingWater);
    on<WaterPlantEvent>(_onWaterPlant);
    on<FilterPlantsByCategoryEvent>(_onFilterPlantsByCategory);
    on<SearchPlantsEvent>(_onSearchPlants);
    on<ToggleFavoritePlantEvent>(_onToggleFavoritePlant);
  }

  Future<void> _onLoadPlants(LoadPlantsEvent event, Emitter<PlantsState> emit) async {
    emit(PlantsLoading());
    final result = await getAllPlantsUseCase(NoParams());
    result.fold(
          (failure) => emit(PlantsError(message: _mapFailureToMessage(failure))),
          (plants) => emit(PlantsLoaded(plants: plants)),
    );
  }

  Future<void> _onLoadPlants(LoadPlantsEvent event, Emitter<PlantsState> emit) async {
    emit(PlantsLoading());
    final result = await getAllPlantsUseCase(const NoParams());
    result.fold(
          (failure) => emit(PlantsError(message: _mapFailureToMessage(failure))),
          (plants) => emit(PlantsLoaded(plants: plants)),
    );
  }

  Future<void> _onWaterPlant(WaterPlantEvent event, Emitter<PlantsState> emit) async {
    final currentState = state;
    if (currentState is PlantsLoaded) {
      emit(PlantsLoading());
      final result = await waterPlantUseCase(
        WaterPlantParams(
          plantId: event.plantId,
          date: DateTime.now(),
        ),
      );
      result.fold(
            (failure) => emit(PlantsError(message: _mapFailureToMessage(failure))),
            (updatedPlant) {
          emit(PlantWatered(plant: updatedPlant));
          add(LoadPlantsEvent());
        },
      );
    }
  }

  Future<void> _onFilterPlantsByCategory(
      FilterPlantsByCategoryEvent event, Emitter<PlantsState> emit) async {
    // Реализовать фильтрацию по категории
  }

  Future<void> _onSearchPlants(SearchPlantsEvent event, Emitter<PlantsState> emit) async {
    // Реализовать поиск растений
  }

  Future<void> _onToggleFavoritePlant(
      ToggleFavoritePlantEvent event, Emitter<PlantsState> emit) async {
    // Реализовать добавление/удаление из избранного
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Ошибка сервера: ${failure.message}';
      case ConnectionFailure:
        return 'Ошибка подключения: ${failure.message}';
      case DatabaseFailure:
        return 'Ошибка базы данных: ${failure.message}';
      case CacheFailure:
        return 'Ошибка кэша: ${failure.message}';
      case ValidationFailure:
        return failure.message;
      case NotFoundFailure:
        return 'Растение не найдено: ${failure.message}';
      default:
        return 'Неожиданная ошибка: ${failure.message}';
    }
  }
}