// ignore_for_file: file_names

import 'dart:async';
import 'dart:math';
import 'package:cyberlife/screens/joint_motor_function.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';

class JointMotorFunctionInstructions extends StatelessWidget {

  final String title = "Joint Motor Function";

  const JointMotorFunctionInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: title);

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Instructions - Range of Motion',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Make sure your device has the necessary sensors.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '2. Hold your device flat and parallel to the ground.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '3. Tap the "Start" button to begin recording accelerometer data.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '4. Tilt your device to observe changes in the X, Y, and Z values.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '5. The calculated angle based on the accelerometer data will be displayed.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Start'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const JointMotorFunction())
                );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
