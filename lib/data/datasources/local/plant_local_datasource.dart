import 'dart:convert';
import 'package:garden_helper/core/error/exceptions.dart';
import 'package:garden_helper/data/models/plant_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PlantLocalDataSource {
  /// Получает кэшированный список растений
  ///
  /// Выбрасывает [CacheException] если данные отсутствуют
  Future<List<PlantModel>> getCachedPlants();

  /// Кэширует список растений
  Future<void> cachePlants(List<PlantModel> plants);

  /// Получает кэшированный список растений, нуждающихся в поливе
  ///
  /// Выбрасывает [CacheException] если данные отсутствуют
  Future<List<PlantModel>> getCachedPlantsNeedingWater();

  /// Обновляет информацию о поливе растения
  Future<PlantModel> updatePlantWatering(String id, DateTime date);
}

class PlantLocalDataSourceImpl implements PlantLocalDataSource {
  final SharedPreferences preferences;
  final String cachedPlantsKey = 'CACHED_PLANTS';

  PlantLocalDataSourceImpl({required this.preferences});

  @override
  Future<List<PlantModel>> getCachedPlants() {
    final jsonString = preferences.getString(cachedPlantsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((jsonPlant) => PlantModel.fromJson(jsonPlant)).toList(),
      );
    } else {
      throw CacheException(message: 'Нет кэшированных данных о растениях');
    }
  }

  @override
  Future<void> cachePlants(List<PlantModel> plants) {
    final List<Map<String, dynamic>> jsonList = plants
        .map((plant) => plant.toJson())
        .toList();
    return preferences.setString(cachedPlantsKey, json.encode(jsonList));
  }

  @override
  Future<List<PlantModel>> getCachedPlantsNeedingWater() async {
    final plants = await getCachedPlants();
    final now = DateTime.now();
    return plants.where((plant) {
      final daysFromLastWatering = now.difference(plant.lastWatered).inDays;
      return daysFromLastWatering >= plant.wateringFrequencyDays;
    }).toList();
  }

  @override
  Future<PlantModel> updatePlantWatering(String id, DateTime date) async {
    final plants = await getCachedPlants();
    final index = plants.indexWhere((plant) => plant.id == id);

    if (index != -1) {
      final updatedPlant = plants[index].copyWith(lastWatered: date);
      plants[index] = updatedPlant;
      await cachePlants(plants);
      return updatedPlant;
    } else {
      throw CacheException(message: 'Растение не найдено в кэше');
    }
  }
}