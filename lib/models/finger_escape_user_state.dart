import 'package:cyberlife/models/angle_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'finger_escape_user_state.g.dart';

@HiveType(typeId: 3)
class FingerEscapeUserState {

  @HiveField(0)
  AngleList supinationAngleList = AngleList();

  @HiveField(1)
  bool complete = false;

  FingerEscapeUserState();

  bool isComplete() {
    return complete;
  }

  AngleList getSupinationAngleList() {
    return supinationAngleList;
  }

  void record(AngleList supinationAngleList) {
    this.supinationAngleList = supinationAngleList;
    complete = true;
  }

  void reset() {
    supinationAngleList = AngleList();
    complete = false;
  }

  @override
  String toString() {
    String result = "Finger Escape User State:\n";

    result += "complete? $complete \n";
    result += "supinationAngleList: $supinationAngleList \n";

    return result;
  }
}
