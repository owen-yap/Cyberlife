import 'package:cyberlife/components/joint-motor-function/motor_function_test_button.dart';
import 'package:cyberlife/constants/strings.dart';
import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/app_state.dart';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:cyberlife/views/joint-motor-function/function_instructions.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_function_results.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_test.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JointMotorFunctionMain extends StatefulWidget {
  const JointMotorFunctionMain({Key? key}) : super(key: key);

  final String title = "Joint Motor Function";

  @override
  State<JointMotorFunctionMain> createState() => _JointMotorFunctionMainState();
}

class _JointMotorFunctionMainState extends State<JointMotorFunctionMain> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);
    final theme = Theme.of(context);
    const defaultVideoPath = "assets/videos/sample.mp4";

    return Consumer<AppStateNotifier>(builder: (context, notifier, child) {
      return Scaffold(
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
                  joint: Joints.shoulder,
                  jointMotorFunctionTestState: notifier.jointMotorFunctionTestState,
                  defaultVideoPath: defaultVideoPath,
                ),
                const SizedBox(height: 24),
                MotorFunctionTestButton(
                  joint: Joints.elbow,
                  jointMotorFunctionTestState: notifier.jointMotorFunctionTestState,
                  defaultVideoPath: defaultVideoPath,
                ),
                const SizedBox(height: 24),
                MotorFunctionTestButton(
                  joint: Joints.knee,
                  jointMotorFunctionTestState: notifier.jointMotorFunctionTestState,
                  defaultVideoPath: defaultVideoPath,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
