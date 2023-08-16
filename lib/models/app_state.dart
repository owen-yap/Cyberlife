import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/finger_escape_user_state.dart';
import 'package:cyberlife/models/grip_release_user_state.dart';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {
  final JointMotorFunctionUserState _jointMotorFunctionUserState =
      JointMotorFunctionUserState();
  final GripReleaseUserState _gripReleaseUserState = GripReleaseUserState();
  final FingerEscapeUserState _fingerEscapeUserState = FingerEscapeUserState();

  JointMotorFunctionUserState get jointMotorFunctionUserState =>
      _jointMotorFunctionUserState;
  GripReleaseUserState get gripReleaseUserState => _gripReleaseUserState;
  FingerEscapeUserState get fingerEscapeUserState => _fingerEscapeUserState;

  // JOINT MOTOR FUNCTION
  void markJointTest(Joints joint, bool completed, AngleList aList) {
    _jointMotorFunctionUserState.markJointTest(joint, completed, aList);
    notifyListeners();
  }

  void resetJointTest(Joints joint) {
    _jointMotorFunctionUserState.resetJointTest(joint);
    notifyListeners();
  }

  // GRIP RELEASE
  void recordGripRelease(int fistsMade) {
    _gripReleaseUserState.record(fistsMade);
    notifyListeners();
  }

  void resetGripRelease() {
    _gripReleaseUserState.reset();
    notifyListeners();
  }

  // FINGER SUPINATION
  void recordFingerEscape(AngleList supinationAngleList) {
    _fingerEscapeUserState.record(supinationAngleList);
    notifyListeners();
  }

  void resetFingerEscape() {
    _fingerEscapeUserState.reset();
    notifyListeners();
  }

  @override
  String toString() {
    String result = "|-----------------------------------------------|\n";
    result += _jointMotorFunctionUserState.toString();
    result += "|-----------------------------------------------|\n";
    result += _gripReleaseUserState.toString();
    result += "|-----------------------------------------------|\n";
    result += _fingerEscapeUserState.toString();
    result += "|-----------------------------------------------|\n";

    return result;
  }
}
