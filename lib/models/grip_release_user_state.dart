import 'package:hive_flutter/hive_flutter.dart';

part 'grip_release_user_state.g.dart';

@HiveType(typeId: 2)
class GripReleaseUserState {
  @HiveField(0)
  int defaultValue = -1;

  @HiveField(1)
  late int fistsMade;
  
  @HiveField(2)
  bool complete = false;

  GripReleaseUserState() {
    fistsMade = defaultValue;
  }

  bool isComplete() {
    return complete;
  }

  int getFistsMade() {
    return fistsMade;
  }

  void record(int fistsMade) {
    this.fistsMade = fistsMade;
    complete = true;
  }

  void reset() {
    fistsMade = -1;
    complete = false;
  }

  @override
  String toString() {
    String result = "Grip Release User State:\n";

    result += "complete? $complete \n";
    result += "fistsMade: $fistsMade \n";

    return result;
  }
}
