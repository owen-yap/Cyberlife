import 'package:cyberlife/models/angle_list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class JointMotorFunctionUserState extends Model {
  bool shoulderComplete;
  AngleList shoulderAngles;
  bool elbowComplete;
  AngleList elbowAngles;
  bool kneeComplete;
  AngleList kneeAngles;

  JointMotorFunctionUserState({
    required this.shoulderComplete,
    required this.shoulderAngles,
    required this.elbowComplete,
    required this.elbowAngles,
    required this.kneeComplete,
    required this.kneeAngles,
    required Widget child
    })
      : super(child: child);

  static JointMotorFunctionUserState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<JointMotorFunctionUserState>();
  }

  @override
  bool updateShouldNotify(JointMotorFunctionUserState oldWidget) {
    return 
    (oldWidget.shoulderComplete != shoulderComplete) || 
    (oldWidget.shoulderAngles != shoulderAngles) || 
    (oldWidget.elbowComplete != elbowComplete) || 
    (oldWidget.elbowAngles != elbowAngles) || 
    (oldWidget.kneeComplete != kneeComplete) || 
    (oldWidget.kneeAngles != kneeAngles);
  }
}
