// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantModelAdapter extends TypeAdapter<PlantModel> {
  @override
  final int typeId = 0;

  @override
  PlantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantModel(
      id: fields[0] as String,
      name: fields[1] as String,
      latinName: fields[2] as String,
      description: fields[3] as String?,
      imageUrl: fields[4] as String?,
      category: fields[5] as int,
      status: fields[6] as int,
      temperature: fields[7] as double,
      light: fields[8] as double,
      humidity: fields[9] as double,
      lastWatered: fields[10] as DateTime,
      lastFertilized: fields[11] as DateTime,
      wateringFrequencyDays: fields[12] as int,
      fertilizingFrequencyDays: fields[13] as int,
      difficultyLevel: fields[14] as int,
      isFavorite: fields[15] as bool,
      addedDate: fields[16] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlantModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.latinName)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.temperature)
      ..writeByte(8)
      ..write(obj.light)
      ..writeByte(9)
      ..write(obj.humidity)
      ..writeByte(10)
      ..write(obj.lastWatered)
      ..writeByte(11)
      ..write(obj.lastFertilized)
      ..writeByte(12)
      ..write(obj.wateringFrequencyDays)
      ..writeByte(13)
      ..write(obj.fertilizingFrequencyDays)
      ..writeByte(14)
      ..write(obj.difficultyLevel)
      ..writeByte(15)
      ..write(obj.isFavorite)
      ..writeByte(16)
      ..write(obj.addedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
