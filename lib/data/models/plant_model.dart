import 'package:garden_helper/domain/entities/plant_entity.dart';
import 'package:hive/hive.dart';

part 'plant_model.g.dart';

@HiveType(typeId: 0)
class PlantModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String latinName;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final int category;

  @HiveField(6)
  final int status;

  @HiveField(7)
  final double temperature;

  @HiveField(8)
  final double light;

  @HiveField(9)
  final double humidity;

  @HiveField(10)
  final DateTime lastWatered;

  @HiveField(11)
  final DateTime lastFertilized;

  @HiveField(12)
  final int wateringFrequencyDays;

  @HiveField(13)
  final int fertilizingFrequencyDays;

  @HiveField(14)
  final int difficultyLevel;

  @HiveField(15)
  final bool isFavorite;

  @HiveField(16)
  final DateTime addedDate;

  PlantModel({
    required this.id,
    required this.name,
    required this.latinName,
    this.description,
    this.imageUrl,
    required this.category,
    required this.status,
    required this.temperature,
    required this.light,
    required this.humidity,
    required this.lastWatered,
    required this.lastFertilized,
    required this.wateringFrequencyDays,
    required this.fertilizingFrequencyDays,
    required this.difficultyLevel,
    this.isFavorite = false,
    required this.addedDate,
  });

  factory PlantModel.fromEntity(PlantEntity entity) {
    return PlantModel(
      id: entity.id,
      name: entity.name,
      latinName: entity.latinName,
      description: entity.description,
      imageUrl: entity.imageUrl,
      category: entity.category.index,
      status: entity.status.index,
      temperature: entity.temperature,
      light: entity.light,
      humidity: entity.humidity,
      lastWatered: entity.lastWatered,
      lastFertilized: entity.lastFertilized,
      wateringFrequencyDays: entity.wateringFrequencyDays,
      fertilizingFrequencyDays: entity.fertilizingFrequencyDays,
      difficultyLevel: entity.difficultyLevel,
      isFavorite: entity.isFavorite,
      addedDate: entity.addedDate,
    );
  }

  PlantEntity toEntity() {
    return PlantEntity(
      id: id,
      name: name,
      latinName: latinName,
      description: description,
      imageUrl: imageUrl,
      category: PlantCategory.values[category],
      status: PlantStatus.values[status],
      temperature: temperature,
      light: light,
      humidity: humidity,
      lastWatered: lastWatered,
      lastFertilized: lastFertilized,
      wateringFrequencyDays: wateringFrequencyDays,
      fertilizingFrequencyDays: fertilizingFrequencyDays,
      difficultyLevel: difficultyLevel,
      isFavorite: isFavorite,
      addedDate: addedDate,
    );
  }

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      name: json['name'],
      latinName: json['latinName'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      status: json['status'],
      temperature: json['temperature'].toDouble(),
      light: json['light'].toDouble(),
      humidity: json['humidity'].toDouble(),
      lastWatered: DateTime.parse(json['lastWatered']),
      lastFertilized: DateTime.parse(json['lastFertilized']),
      wateringFrequencyDays: json['wateringFrequencyDays'],
      fertilizingFrequencyDays: json['fertilizingFrequencyDays'],
      difficultyLevel: json['difficultyLevel'],
      isFavorite: json['isFavorite'],
      addedDate: DateTime.parse(json['addedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latinName': latinName,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'status': status,
      'temperature': temperature,
      'light': light,
      'humidity': humidity,
      'lastWatered': lastWatered.toIso8601String(),
      'lastFertilized': lastFertilized.toIso8601String(),
      'wateringFrequencyDays': wateringFrequencyDays,
      'fertilizingFrequencyDays': fertilizingFrequencyDays,
      'difficultyLevel': difficultyLevel,
      'isFavorite': isFavorite,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  PlantModel copyWith({
    String? id,
    String? name,
    String? latinName,
    String? description,
    String? imageUrl,
    int? category,
    int? status,
    double? temperature,
    double? light,
    double? humidity,
    DateTime? lastWatered,
    DateTime? lastFertilized,
    int? wateringFrequencyDays,
    int? fertilizingFrequencyDays,
    int? difficultyLevel,
    bool? isFavorite,
    DateTime? addedDate,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latinName: latinName ?? this.latinName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      status: status ?? this.status,
      temperature: temperature ?? this.temperature,
      light: light ?? this.light,
      humidity: humidity ?? this.humidity,
      lastWatered: lastWatered ?? this.lastWatered,
      lastFertilized: lastFertilized ?? this.lastFertilized,
      wateringFrequencyDays: wateringFrequencyDays ?? this.wateringFrequencyDays,
      fertilizingFrequencyDays: fertilizingFrequencyDays ?? this.fertilizingFrequencyDays,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      isFavorite: isFavorite ?? this.isFavorite,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}