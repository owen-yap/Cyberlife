import 'package:cyberlife/constants/strings.dart';
import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:cyberlife/theme.dart';
import 'package:cyberlife/views/joint-motor-function/function_instructions.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_function_results.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MotorFunctionTestButton extends StatefulWidget {
  final Joints joint;
  final JointMotorFunctionUserState jointMotorFunctionTestState;
  final String defaultVideoPath;

  const MotorFunctionTestButton(
      {Key? key,
      required this.joint,
      required this.jointMotorFunctionTestState,
      required this.defaultVideoPath})
      : super(key: key);

  @override
  _MotorFunctionTestButtonState createState() =>
      _MotorFunctionTestButtonState();
}

class _MotorFunctionTestButtonState extends State<MotorFunctionTestButton> {
  @override
  Widget build(BuildContext context) {
    double circleRadius = 20;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;

    Joints joint = widget.joint;
    String label = Strings.fromJointEnum[joint]!;
    bool isJointComplete =
        widget.jointMotorFunctionTestState.isJointComplete(joint);

    return SizedBox(
        width: screenWidth - 30,
        child: ElevatedButton(
          onPressed: () {
            if (kDebugMode) {
              print('$label button pressed in Joint Motor Function!');
            }
            if (isJointComplete) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JointMotorFunctionResults(
                      joint: joint,
                      angleList: widget.jointMotorFunctionTestState
                          .getJointAngleList(joint),
                    ),
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FunctionInstructions(
                      title: Strings.fromJointEnum[joint]!,
                      videoPath: widget.defaultVideoPath,
                      testPage: JointMotorFunctionTest(
                        joint: joint,
                      ),
                    ),
                  ));
            }
          },
          style: isJointComplete
              ? Theme.of(context).elevatedButtonTheme.style
              : Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor:
                      const MaterialStatePropertyAll(Colors.white)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: circleRadius,
              ),
              Text(label),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: circleRadius,
                    child: Icon(
                      isJointComplete ? Icons.check : Icons.access_time,
                      color: Colors.grey.shade600,
                      size: circleRadius,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: circleRadius,
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppTheme.lightGreen,
                      size: circleRadius,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
