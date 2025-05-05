import 'package:equatable/equatable.dart';

enum PlantCategory {
  indoor,
  garden,
  greenhouse,
  fruit,
  decorative,
  vegetable,
  flowering,
}

enum PlantStatus {
  healthy,
  needsWater,
  needsAttention,
  sick,
}

class PlantEntity extends Equatable {
  final String id;
  final String name;
  final String latinName;
  final String? description;
  final String? imageUrl;
  final PlantCategory category;
  final PlantStatus status;
  final double temperature;
  final double light;
  final double humidity;
  final DateTime lastWatered;
  final DateTime lastFertilized;
  final int wateringFrequencyDays;
  final int fertilizingFrequencyDays;
  final int difficultyLevel; // От 1 до 5
  final bool isFavorite;
  final DateTime addedDate;

  const PlantEntity({
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

  bool get needsWatering {
    final daysFromLastWatering = DateTime.now().difference(lastWatered).inDays;
    return daysFromLastWatering >= wateringFrequencyDays;
  }

  bool get needsFertilizing {
    final daysFromLastFertilizing = DateTime.now().difference(lastFertilized).inDays;
    return daysFromLastFertilizing >= fertilizingFrequencyDays;
  }

  int get daysUntilNextWatering {
    final daysFromLastWatering = DateTime.now().difference(lastWatered).inDays;
    return wateringFrequencyDays - daysFromLastWatering;
  }

  int get daysUntilNextFertilizing {
    final daysFromLastFertilizing = DateTime.now().difference(lastFertilized).inDays;
    return fertilizingFrequencyDays - daysFromLastFertilizing;
  }

  PlantEntity copyWith({
    String? id,
    String? name,
    String? latinName,
    String? description,
    String? imageUrl,
    PlantCategory? category,
    PlantStatus? status,
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
    return PlantEntity(
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

  @override
  List<Object?> get props => [
    id,
    name,
    latinName,
    description,
    imageUrl,
    category,
    status,
    temperature,
    light,
    humidity,
    lastWatered,
    lastFertilized,
    wateringFrequencyDays,
    fertilizingFrequencyDays,
    difficultyLevel,
    isFavorite,
    addedDate,
  ];
}