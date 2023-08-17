import 'package:hive_flutter/hive_flutter.dart';

part 'joints.g.dart';

@HiveType(typeId: 6)
enum Joints {
  @HiveField(0)
  shoulder,

  @HiveField(1)
  elbow,

  @HiveField(2)
  knee
}