// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chargers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChargerModelAdapter extends TypeAdapter<ChargerModel> {
  @override
  final int typeId = 1;

  @override
  ChargerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChargerModel(
      data: (fields[0] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChargerModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
