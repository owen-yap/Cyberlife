// ignore_for_file: file_names

import 'dart:async';

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

  List<double>? _userAccelerometerValues;
  final _jointMotorFunctionTest = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);

    final userAccelerometer =
    _userAccelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

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
                  child:
                    SizedBox(
                        width: 300.0,
                        height: 100.0,
                        child: Column(
                          children: [
                            Card(child: Text('X Value: ')),
                            Card(child: Text('Y Value: ')),
                            Card(child: Text('Z Value: ')),
                          ]

                        ),
                    )

              ),
            ),
          ],
        ),
      ),
    );
  }
}

