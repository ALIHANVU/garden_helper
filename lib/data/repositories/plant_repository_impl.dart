import 'package:dartz/dartz.dart';
import 'package:garden_helper/core/error/exceptions.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:garden_helper/core/network/network_info.dart';
import 'package:garden_helper/data/datasources/local/plant_local_datasource.dart';
import 'package:garden_helper/data/datasources/remote/plant_remote_datasource.dart';
import 'package:garden_helper/data/models/plant_model.dart';
import 'package:garden_helper/domain/entities/plant_entity.dart';
import 'package:garden_helper/domain/repositories/plant_repository.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantLocalDataSource localDataSource;
  final PlantRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlantRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PlantEntity>>> getAllPlants() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePlants = await remoteDataSource.getPlants();
        await localDataSource.cachePlants(remotePlants);
        return Right(remotePlants.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return _getLocalPlants();
      }
    } else {
      return _getLocalPlants();
    }
  }

  Future<Either<Failure, List<PlantEntity>>> _getLocalPlants() async {
    try {
      final localPlants = await localDataSource.getCachedPlants();
      return Right(localPlants.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PlantEntity>> getPlantById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePlant = await remoteDataSource.getPlantById(id);
        return Right(remotePlant.toEntity());
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return _getLocalPlantById(id);
      }
    } else {
      return _getLocalPlantById(id);
    }
  }

  Future<Either<Failure, PlantEntity>> _getLocalPlantById(String id) async {
    try {
      final localPlants = await localDataSource.getCachedPlants();
      final plant = localPlants.firstWhere((plant) => plant.id == id);
      return Right(plant.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(NotFoundFailure(message: 'Растение не найдено в локальной базе'));
    }
  }

  @override
  Future<Either<Failure, PlantEntity>> addPlant(PlantEntity plant) async {
    final plantModel = PlantModel.fromEntity(plant);

    if (await networkInfo.isConnected) {
      try {
        final remotePlant = await remoteDataSource.addPlant(plantModel);
        final localPlants = await localDataSource.getCachedPlants();
        localPlants.add(remotePlant);
        await localDataSource.cachePlants(localPlants);
        return Right(remotePlant.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return _addPlantLocally(plantModel);
      }
    } else {
      return _addPlantLocally(plantModel);
    }
  }

  Future<Either<Failure, PlantEntity>> _addPlantLocally(PlantModel plant) async {
    try {
      final localPlants = await localDataSource.getCachedPlants();
      localPlants.add(plant);
      await localDataSource.cachePlants(localPlants);
      return Right(plant.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PlantEntity>> updatePlant(PlantEntity plant) async {
    final plantModel = PlantModel.fromEntity(plant);

    if (await networkInfo.isConnected) {
      try {
        final remotePlant = await remoteDataSource.updatePlant(plantModel);
        final localPlants = await localDataSource.getCachedPlants();
        final index = localPlants.indexWhere((p) => p.id == plant.id);
        if (index != -1) {
          localPlants[index] = remotePlant;
          await localDataSource.cachePlants(localPlants);
        }
        return Right(remotePlant.toEntity());
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return _updatePlantLocally(plantModel);
      }
    } else {
      return _updatePlantLocally(plantModel);
    }
  }

  Future<Either<Failure, PlantEntity>> _updatePlantLocally(PlantModel plant) async {
    try {
      final localPlants = await localDataSource.getCachedPlants();
      final index = localPlants.indexWhere((p) => p.id == plant.id);

      if (index != -1) {
        localPlants[index] = plant;
        await localDataSource.cachePlants(localPlants);
        return Right(plant.toEntity());
      } else {
        return Left(NotFoundFailure(message: 'Растение не найдено в локальной базе'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePlant(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deletePlant(id);
        final localPlants = await localDataSource.getCachedPlants();
        localPlants.removeWhere((plant) => plant.id == id);
        await localDataSource.cachePlants(localPlants);
        return Right(result);
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return _deletePlantLocally(id);
      }
    } else {
      return _deletePlantLocally(id);
    }
  }

  Future<Either<Failure, bool>> _deletePlantLocally(String id) async {
    try {
      final localPlants = await localDataSource.getCachedPlants();
      final initialLength = localPlants.length;
      localPlants.removeWhere((plant) => plant.id == id);

      if (initialLength == localPlants.length) {
        return Left(NotFoundFailure(message: 'Растение не найдено в локальной базе'));
      }

      await localDataSource.cachePlants(localPlants);
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PlantEntity>> waterPlant(String id, DateTime date) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePlant = await remoteDataSource.waterPlant(id, date);
        final plantEntity = remotePlant.toEntity();

        try {
          await localDataSource.updatePlantWatering(id, date);
        } catch (_) {}

        return Right(plantEntity);
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errorCode: e.statusCode));
      } catch (e) {
        return _waterPlantLocally(id, date);
      }
    } else {
      return _waterPlantLocally(id, date);
    }
  }

  Future<Either<Failure, PlantEntity>> _waterPlantLocally(String id, DateTime date) async {
    try {
      final updatedPlant = await localDataSource.updatePlantWatering(id, date);
      return Right(updatedPlant.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PlantEntity>>> getPlantsNeedingWater() async {
    try {
      final plants = await localDataSource.getCachedPlantsNeedingWater();
      return Right(plants.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PlantEntity>>> getPlantsNeedingAttention() async {
    try {
      final allPlants = await localDataSource.getCachedPlants();
      final plantsNeedingAttention = allPlants.where((plant) {
        return plant.status == PlantStatus.needsAttention.index ||
            plant.status == PlantStatus.sick.index;
      }).toList();

      return Right(plantsNeedingAttention.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PlantEntity>> toggleFavorite(String id) async {
    try {
      final localPlants = await localDataSource.getCachedPlants();
      final index = localPlants.indexWhere((plant) => plant.id == id);

      if (index != -1) {
        final plant = localPlants[index];
        final updatedPlant = plant.copyWith(isFavorite: !plant.isFavorite);
        localPlants[index] = updatedPlant;
        await localDataSource.cachePlants(localPlants);
        return Right(updatedPlant.toEntity());
      } else {
        return Left(NotFoundFailure(message: 'Растение не найдено'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PlantEntity>>> getFavoritePlants() async {
    try {
      final allPlants = await localDataSource.getCachedPlants();
      final favoritePlants = allPlants.where((plant) => plant.isFavorite).toList();
      return Right(favoritePlants.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PlantEntity>>> getPlantsByCategory(PlantCategory category) async {
    try {
      final allPlants = await localDataSource.getCachedPlants();
      final filteredPlants = allPlants
          .where((plant) => plant.category == category.index)
          .toList();
      return Right(filteredPlants.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PlantEntity>>> searchPlantsByName(String query) async {
    try {
      final allPlants = await localDataSource.getCachedPlants();
      final filteredPlants = allPlants
          .where((plant) =>
      plant.name.toLowerCase().contains(query.toLowerCase()) ||
          plant.latinName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return Right(filteredPlants.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> syncPlantsWithCloud() async {
    if (await networkInfo.isConnected) {
      try {
        final localPlants = await localDataSource.getCachedPlants();
        final syncedPlants = await remoteDataSource.syncPlants(localPlants);
        await localDataSource.cachePlants(syncedPlants);
        return const Right(true);
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
  Future<Either<Failure, PlantEntity>> fertilizePlant(String id, DateTime date) async {
    // Реализовать метод аналогично waterPlant
    // В этой версии приложения не реализовано
    return Left(UnexpectedFailure(message: 'Функция в разработке'));
  }
}