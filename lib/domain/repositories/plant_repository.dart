import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/domain/entities/plant_entity.dart';

abstract class PlantRepository {
  /// Получает список всех растений пользователя
  Future<Either<Failure, List<PlantEntity>>> getAllPlants();

  /// Получает подробную информацию о растении по ID
  Future<Either<Failure, PlantEntity>> getPlantById(String id);

  /// Добавляет новое растение
  Future<Either<Failure, PlantEntity>> addPlant(PlantEntity plant);

  /// Обновляет информацию о растении
  Future<Either<Failure, PlantEntity>> updatePlant(PlantEntity plant);

  /// Удаляет растение по ID
  Future<Either<Failure, bool>> deletePlant(String id);

  /// Отмечает полив растения
  Future<Either<Failure, PlantEntity>> waterPlant(String id, DateTime date);

  /// Отмечает подкормку растения
  Future<Either<Failure, PlantEntity>> fertilizePlant(String id, DateTime date);

  /// Получает список растений, требующих полива
  Future<Either<Failure, List<PlantEntity>>> getPlantsNeedingWater();

  /// Получает список растений, требующих внимания
  Future<Either<Failure, List<PlantEntity>>> getPlantsNeedingAttention();

  /// Добавляет растение в избранное
  Future<Either<Failure, PlantEntity>> toggleFavorite(String id);

  /// Получает список избранных растений
  Future<Either<Failure, List<PlantEntity>>> getFavoritePlants();

  /// Получает список растений по категории
  Future<Either<Failure, List<PlantEntity>>> getPlantsByCategory(PlantCategory category);

  /// Поиск растений по названию
  Future<Either<Failure, List<PlantEntity>>> searchPlantsByName(String query);

  /// Синхронизация данных с облаком
  Future<Either<Failure, bool>> syncPlantsWithCloud();
}