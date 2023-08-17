import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/finger_escape_user_state.dart';
import 'package:cyberlife/models/grip_release_user_state.dart';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'app_state.g.dart';

@HiveType(typeId: 0)
class AppStateNotifier extends ChangeNotifier {
  @HiveField(0)
  JointMotorFunctionUserState _jointMotorFunctionUserState =
      JointMotorFunctionUserState();
  JointMotorFunctionUserState get jointMotorFunctionUserState =>
      _jointMotorFunctionUserState;

  @HiveField(1)
  GripReleaseUserState _gripReleaseUserState = GripReleaseUserState();
  GripReleaseUserState get gripReleaseUserState => _gripReleaseUserState;

  @HiveField(2)
  FingerEscapeUserState _fingerEscapeUserState = FingerEscapeUserState();
  FingerEscapeUserState get fingerEscapeUserState => _fingerEscapeUserState;

  static defaultAppStateNotifier() {
    AppStateNotifier(JointMotorFunctionUserState(), GripReleaseUserState(),
        FingerEscapeUserState());
  }

  AppStateNotifier(
      JointMotorFunctionUserState jointMotorFunctionUserState,
      GripReleaseUserState gripReleaseUserState,
      FingerEscapeUserState fingerEscapeUserState) {
    _jointMotorFunctionUserState = jointMotorFunctionUserState;
    _gripReleaseUserState = gripReleaseUserState;
    _fingerEscapeUserState = fingerEscapeUserState;
  }

  // JOINT MOTOR FUNCTION
  void markJointTest(Joints joint, bool completed, AngleList aList) {
    _jointMotorFunctionUserState.markJointTest(joint, completed, aList);
    post();
  }

  void resetJointTest(Joints joint) {
    _jointMotorFunctionUserState.resetJointTest(joint);
    post();
  }

  // GRIP RELEASE
  void recordGripRelease(int fistsMade) {
    _gripReleaseUserState.record(fistsMade);
    post();
  }

  void resetGripRelease() {
    _gripReleaseUserState.reset();
    post();
  }

  // FINGER SUPINATION
  void recordFingerEscape(AngleList supinationAngleList) {
    _fingerEscapeUserState.record(supinationAngleList);
    post();
  }

  void resetFingerEscape() {
    _fingerEscapeUserState.reset();
    post();
  }

  void post() async {
    // Save data first
    Box<AppStateNotifier> storage = await Hive.openBox('storage');
    await storage.put('userState', this);
    super.notifyListeners();
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
