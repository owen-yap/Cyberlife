
import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/views/grip-release-test/grip_release_video_instructions.dart';
import 'package:cyberlife/views/joint-motor-function/joint_motor_function_main.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';

class GripReleaseInstructions extends StatelessWidget {
  final String title = "Grip Release Test";

  const GripReleaseInstructions({super.key});

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
                'Grip Release Test',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Instructions:',
                  '1. Lorem.',
                  '2. ipsum.',
                  '3. sit.',
                  '4. dolor.',
                  '5. arnet.',
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
                          builder: (context) => const GripReleaseVideoInstructions(),
                          ));
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
