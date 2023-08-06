import 'dart:async';
import 'dart:math';
import 'package:cyberlife/components/stopwatch_circle.dart';
import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/constants/strings.dart';
import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/app_state.dart';
import 'package:cyberlife/theme.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_function_results.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cyberlife/models/angle_list.dart';

class JointMotorFunctionTest extends StatefulWidget {
  final Joints joint;

  const JointMotorFunctionTest({Key? key, required this.joint})
      : super(key: key);

  @override
  State<JointMotorFunctionTest> createState() => _JointMotorFunctionTestState();
}

class _JointMotorFunctionTestState extends State<JointMotorFunctionTest> {
  AngleList aList = AngleList();
  bool stopwatchRunning = false;
  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void toggleRecording() {
    setState(() {
      stopwatchRunning = !stopwatchRunning;
      if (stopwatchRunning) {
        aList = AngleList();
      }
    });
  }

  double calculateAngle(double? x, double? y) {
    if (x == null || y == null) return 0;
    double res = -atan2(x, y) * (180 / pi);
    if (stopwatchRunning) aList.add(res);
    return res;
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String jointString = Strings.fromJointEnum[widget.joint]!;
    CommonAppBar appBar = CommonAppBar(title: "$jointString Test");
    final accelerometer = _accelerometerValues?.toList();

    final appStateNotifier = Provider.of<AppStateNotifier>(context);

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          children: [
            const Expanded(child: SizedBox(height: 36)),
            StopwatchCircle(
              running: stopwatchRunning,
              width: 225,
              height: 225,
            ),
            const SizedBox(height: 36),
            Text(
              "Angle:",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.lightGreen, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                calculateAngle(accelerometer?[0], accelerometer?[2])
                    .toStringAsFixed(3),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                    child: SizedBox(
                  width: 10,
                )),
                ElevatedButton(
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style!
                        .copyWith(
                          minimumSize: const MaterialStatePropertyAll(Size(
                              150, 150)), // Set the desired width and height
                          backgroundColor: stopwatchRunning
                              ? const MaterialStatePropertyAll(AppTheme.red)
                              : const MaterialStatePropertyAll(
                                  AppTheme.lightGreen),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 56.0),
                          ),
                          shape: MaterialStateProperty.all(
                              const CircleBorder(side: BorderSide.none)),
                        ),
                    onPressed: toggleRecording,
                    child: Text(
                      stopwatchRunning ? "Stop" : "Start",
                      style: Theme.of(context).textTheme.displayMedium,
                    )),
                const SizedBox(width: 16),
                !stopwatchRunning && !aList.isEmpty()
                    ? ElevatedButton(
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                              minimumSize: const MaterialStatePropertyAll(
                                  Size(150, 150)), //
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 56.0),
                              ),
                              shape: MaterialStateProperty.all(
                                  const CircleBorder(side: BorderSide.none)),
                            ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JointMotorFunctionResults(
                                  joint: widget.joint,
                                  angleList: aList,
                                ),
                              ));
                        },
                        child: Text(
                          "Continue",
                          style: Theme.of(context).textTheme.displayMedium,
                        ))
                    : const SizedBox.shrink(),
                const Expanded(
                    child: SizedBox(
                  width: 10,
                )),
              ],
            ),
            const Expanded(
              child: SizedBox(height: 36),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
