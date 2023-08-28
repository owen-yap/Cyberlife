// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joints.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JointsAdapter extends TypeAdapter<Joints> {
  @override
  final int typeId = 6;

  @override
  Joints read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Joints.shoulder;
      case 1:
        return Joints.elbow;
      case 2:
        return Joints.knee;
      default:
        return Joints.shoulder;
    }
  }

  @override
  void write(BinaryWriter writer, Joints obj) {
    switch (obj) {
      case Joints.shoulder:
        writer.writeByte(0);
        break;
      case Joints.elbow:
        writer.writeByte(1);
        break;
      case Joints.knee:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JointsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
