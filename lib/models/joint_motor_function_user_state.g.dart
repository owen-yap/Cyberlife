// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joint_motor_function_user_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JointMotorFunctionUserStateAdapter
    extends TypeAdapter<JointMotorFunctionUserState> {
  @override
  final int typeId = 1;

  @override
  JointMotorFunctionUserState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JointMotorFunctionUserState()
      ..stateMap = (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as Joints, (v as Map).cast<String, dynamic>()));
  }

  @override
  void write(BinaryWriter writer, JointMotorFunctionUserState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.stateMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JointMotorFunctionUserStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
