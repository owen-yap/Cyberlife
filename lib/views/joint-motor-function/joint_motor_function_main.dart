import 'package:cyberlife/components/joint-motor-function/motor_function_test_button.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:cyberlife/views/joint-motor-function/function_instructions.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_test.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';

class JointMotorFunctionMain extends StatefulWidget {
  const JointMotorFunctionMain({Key? key}) : super(key: key);

  final String title = "Joint Motor Function";

  @override
  State<JointMotorFunctionMain> createState() => _JointMotorFunctionMainState();
}

class _JointMotorFunctionMainState extends State<JointMotorFunctionMain> {
  bool shoulderComplete = false;
  AngleList shoulderAngles = AngleList();
  bool elbowComplete = false;
  AngleList elbowAngles = AngleList();
  bool kneeComplete = false;
  AngleList kneeAngles = AngleList();

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);
    final theme = Theme.of(context);
    const defaultVideoPath = "assets/videos/sample.mp4";

    return JointMotorFunctionUserState(
      shoulderComplete: shoulderComplete,
      shoulderAngles: shoulderAngles,
      elbowComplete: elbowComplete,
      elbowAngles: elbowAngles,
      kneeComplete: kneeComplete,
      kneeAngles: kneeAngles,
      child: Scaffold(
        appBar: appBar,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 36),
                Text(
                  'Range of Motion',
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Perform all tests to completion',
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 48),
                MotorFunctionTestButton(
                  label: 'Shoulder',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FunctionInstructions(
                                  title: "Shoulder",
                                  videoPath: defaultVideoPath,
                                  testPage: JointMotorFunctionTest(
                                    title: "Shoulder",
                                  ),
                                )));
                  },
                  isCompleted: shoulderComplete,
                ),
                const SizedBox(height: 24),
                MotorFunctionTestButton(
                  label: 'Elbow',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FunctionInstructions(
                                  title: "Elbow",
                                  videoPath: defaultVideoPath,
                                  testPage: JointMotorFunctionTest(
                                    title: "Elbow",
                                  ),
                                )));
                  },
                  isCompleted: elbowComplete,
                ),
                const SizedBox(height: 24),
                MotorFunctionTestButton(
                  label: 'Knee',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FunctionInstructions(
                                  title: "Knee",
                                  videoPath: defaultVideoPath,
                                  testPage: JointMotorFunctionTest(
                                    title: "Knee",
                                  ),
                                )));
                  },
                  isCompleted: kneeComplete,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
