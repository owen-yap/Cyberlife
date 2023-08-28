// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'angle_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AngleListAdapter extends TypeAdapter<AngleList> {
  @override
  final int typeId = 5;

  @override
  AngleList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AngleList()..angleList = (fields[0] as List).cast<double>();
  }

  @override
  void write(BinaryWriter writer, AngleList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.angleList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AngleListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
