// ignore_for_file: file_names

import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class JointMotorFunction extends StatefulWidget {
  const JointMotorFunction({Key? key}) : super(key: key);

  final String title = "Joint Motor Function";

  @override
  State<JointMotorFunction> createState() => _JointMotorFunctionState();
}

class _JointMotorFunctionState extends State<JointMotorFunction> {

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text("Pain Map"),
              onPressed: () {
                gyroscopeEvents.listen((GyroscopeEvent event) {
                  print(event);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}