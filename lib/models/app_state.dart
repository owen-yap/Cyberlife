import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {
  final JointMotorFunctionUserState _jointMotorFunctionTestState =
      JointMotorFunctionUserState();

  JointMotorFunctionUserState get jointMotorFunctionTestState =>
      _jointMotorFunctionTestState;

  void markJointTest(Joints joint, bool completed, AngleList aList) {
    _jointMotorFunctionTestState.markJointTest(joint, completed, aList);
    notifyListeners();
  }

  void resetJointTest(Joints joint) {
    _jointMotorFunctionTestState.resetJointTest(joint);
    notifyListeners();
  }
}
