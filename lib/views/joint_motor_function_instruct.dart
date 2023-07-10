<<<<<<<< HEAD:lib/screens/joint_motor_function/joint_motor_function_instruct.dart
import 'dart:async';
import 'dart:math';
import 'package:cyberlife/screens/joint_motor_function/joint_motor_function_main.dart';
========
import 'package:cyberlife/views/joint_motor_function.dart';
>>>>>>>> cda3ef3f02322684c4639b26b6ee999deda31285:lib/views/joint_motor_function_instruct.dart
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';

class JointMotorFunctionInstructions extends StatelessWidget {
  final String title = "Joint Motor Function";

  const JointMotorFunctionInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: title);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: SizedBox(),
              ),
              const Icon(
                Icons.info_outline,
                size: 120,
              ),
              const SizedBox(height: 48),
              Text(
                'Range of Motion',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Instructions:',
                  '1. Make sure your device has the necessary sensors.',
                  '2. Hold your device flat and parallel to the ground.',
                  '3. Tap the "Start" button to begin recording accelerometer data.',
                  '4. Tilt your device to observe changes in the X, Y, and Z values.',
                  '5. The calculated angle based on the accelerometer data will be displayed.',
                ]
                    .map(
                      (instruction) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          instruction,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JointMotorFunctionMain()));
                },
              ),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
