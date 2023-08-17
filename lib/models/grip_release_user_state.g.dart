// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grip_release_user_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GripReleaseUserStateAdapter extends TypeAdapter<GripReleaseUserState> {
  @override
  final int typeId = 2;

  @override
  GripReleaseUserState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GripReleaseUserState()
      ..defaultValue = fields[0] as int
      ..fistsMade = fields[1] as int
      ..complete = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, GripReleaseUserState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.defaultValue)
      ..writeByte(1)
      ..write(obj.fistsMade)
      ..writeByte(2)
      ..write(obj.complete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GripReleaseUserStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
