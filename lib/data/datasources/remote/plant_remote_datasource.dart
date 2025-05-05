import 'dart:convert';
import 'package:garden_helper/core/error/exceptions.dart';
import 'package:garden_helper/data/models/plant_model.dart';
import 'package:http/http.dart' as http;

abstract class PlantRemoteDataSource {
  /// Получает список растений с сервера
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<List<PlantModel>> getPlants();

  /// Получает детальную информацию о растении по ID
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<PlantModel> getPlantById(String id);

  /// Добавляет новое растение на сервер
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<PlantModel> addPlant(PlantModel plant);

  /// Обновляет информацию о растении на сервере
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<PlantModel> updatePlant(PlantModel plant);

  /// Удаляет растение с сервера
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<bool> deletePlant(String id);

  /// Обновляет информацию о поливе растения на сервере
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<PlantModel> waterPlant(String id, DateTime date);

  /// Синхронизирует данные о растениях с сервером
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<List<PlantModel>> syncPlants(List<PlantModel> localPlants);
}

class PlantRemoteDataSourceImpl implements PlantRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://api.gardenhelper.com/api/v1'; // Заглушка

  PlantRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PlantModel>> getPlants() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/plants'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((jsonPlant) => PlantModel.fromJson(jsonPlant)).toList();
      } else {
        throw ServerException(
          message: 'Ошибка при получении растений',
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
  Future<PlantModel> getPlantById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/plants/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return PlantModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Растение не найдено');
      } else {
        throw ServerException(
          message: 'Ошибка при получении растения',
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
  Future<PlantModel> addPlant(PlantModel plant) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/plants'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(plant.toJson()),
      );

      if (response.statusCode == 201) {
        return PlantModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
          message: 'Ошибка при добавлении растения',
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
  Future<PlantModel> updatePlant(PlantModel plant) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/plants/${plant.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(plant.toJson()),
      );

      if (response.statusCode == 200) {
        return PlantModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Растение не найдено');
      } else {
        throw ServerException(
          message: 'Ошибка при обновлении растения',
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
  Future<bool> deletePlant(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/plants/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Растение не найдено');
      } else {
        throw ServerException(
          message: 'Ошибка при удалении растения',
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
  Future<PlantModel> waterPlant(String id, DateTime date) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/plants/$id/water'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'date': date.toIso8601String()}),
      );

      if (response.statusCode == 200) {
        return PlantModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Растение не найдено');
      } else {
        throw ServerException(
          message: 'Ошибка при поливе растения',
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
  Future<List<PlantModel>> syncPlants(List<PlantModel> localPlants) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/plants/sync'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'plants': localPlants.map((plant) => plant.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['plants'];
        return jsonList.map((jsonPlant) => PlantModel.fromJson(jsonPlant)).toList();
      } else {
        throw ServerException(
          message: 'Ошибка при синхронизации растений',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }
}