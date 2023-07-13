import 'package:cyberlife/models/angle_list.dart';
import 'package:flutter/material.dart';

class JointMotorFunctionUserState {
  List<Function> listeners = <Function>[];

  bool shoulderComplete = false;
  AngleList shoulderAngles = AngleList();
  bool elbowComplete = false;
  AngleList elbowAngles = AngleList();
  bool kneeComplete = false;
  AngleList kneeAngles = AngleList();

  bool get isShoulderComplete => shoulderComplete;
  AngleList get shoulderAngleList => shoulderAngles;
  bool get isElbowComplete => elbowComplete;
  AngleList get elbowAngleList => elbowAngles;
  bool get isKneeComplete => kneeComplete;
  AngleList get kneeAngleList => kneeAngles;

  // TODO: Repalce with one function + enums
  void markShoulderTest(bool completed, AngleList? angles) {
    assert(!(completed && angles == null));
    shoulderComplete = completed;
    shoulderAngles = angles ?? AngleList();
  }

  void markElbowTest(bool completed, AngleList? angles) {
    assert(!(completed && angles == null));
    elbowComplete = completed;
    elbowAngles = angles ?? AngleList();
  }

  void markKneeTest(bool completed, AngleList? angles) {
    assert(!(completed && angles == null));
    kneeComplete = completed;
    kneeAngles = angles ?? AngleList();
  }
}
