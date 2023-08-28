// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finger_escape_user_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FingerEscapeUserStateAdapter extends TypeAdapter<FingerEscapeUserState> {
  @override
  final int typeId = 3;

  @override
  FingerEscapeUserState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FingerEscapeUserState()
      ..supinationAngleList = fields[0] as AngleList
      ..complete = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, FingerEscapeUserState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.supinationAngleList)
      ..writeByte(1)
      ..write(obj.complete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FingerEscapeUserStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
