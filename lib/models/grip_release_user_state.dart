import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/views/grip-release-test/grip_release_test.dart';

class GripReleaseUserState {
  int defaultValue = -1;
  late int fistsMade;
  bool complete = false;

  GripReleaseUserState() {
    fistsMade = defaultValue;
  }

  bool isComplete(Joints joint) {
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
}
