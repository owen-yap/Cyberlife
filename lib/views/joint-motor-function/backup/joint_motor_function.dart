// ignore_for_file: file_names

import 'dart:async';
import 'dart:math';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cyberlife/models/angle_list.dart';

class JointMotorFunction extends StatefulWidget {
  const JointMotorFunction({Key? key}) : super(key: key);

  final String title = "Joint Motor Function";

  @override
  State<JointMotorFunction> createState() => _JointMotorFunctionState();
}

class _JointMotorFunctionState extends State<JointMotorFunction> {
  AngleList aList = AngleList();
  bool recording = false;

  void toggleRecording() {
    if (recording == false) {
      recording = true;
      aList = AngleList();
    } else {
      recording = false;
    }
  }

  double calculateAngle(double? x, double? y) {
    if (x == null || y == null) return 0;
    double res = -atan2(x, y) * (180 / pi);
    if (recording) aList.add(res);
    return res;
  }

  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);

    final accelerometer = _accelerometerValues?.toList();

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.black38),
              ),
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 300.0,
                    height: 100.0,
                    child: Column(children: [
                      Card(
                          child: Text(
                              'X Value: ${accelerometer?[0].toStringAsFixed(1)}')),
                      Card(
                          child: Text(
                              'Y Value: ${accelerometer?[1].toStringAsFixed(1)}')),
                      Card(
                          child: Text(
                              'Z Value: ${accelerometer?[2].toStringAsFixed(1)}')),
                      Card(
                          child: Text(
                              'Angle: ${calculateAngle(accelerometer?[0], accelerometer?[2]).toStringAsFixed(3)}')),
                    ]),
                  )),
            ),
            ElevatedButton(
              child: Text(recording ? "Stop" : "Start"),
              onPressed: () {
                toggleRecording();
              },
            ),
            aList.generateChart(),
          ],
        ),
      ),
    );
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
  void dispose() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
