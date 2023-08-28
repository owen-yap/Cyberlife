// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppStateNotifierAdapter extends TypeAdapter<AppStateNotifier> {
  @override
  final int typeId = 0;

  @override
  AppStateNotifier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    JointMotorFunctionUserState _jointMotorFunctionUserState =
        fields[0] as JointMotorFunctionUserState;
    GripReleaseUserState _gripReleaseUserState =
        fields[1] as GripReleaseUserState;
    FingerEscapeUserState _fingerEscapeUserState =
        fields[2] as FingerEscapeUserState;

    return AppStateNotifier(_jointMotorFunctionUserState, _gripReleaseUserState,
        _fingerEscapeUserState);
  }

  @override
  void write(BinaryWriter writer, AppStateNotifier obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._jointMotorFunctionUserState)
      ..writeByte(1)
      ..write(obj._gripReleaseUserState)
      ..writeByte(2)
      ..write(obj._fingerEscapeUserState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppStateNotifierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
