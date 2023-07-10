// ignore_for_file: file_names

import 'package:cyberlife/views/joint_motor_function/joint_motor_function.dart';
import 'package:cyberlife/views/joint_motor_function/joint_motor_function_instruct.dart';
import 'package:cyberlife/views/open_close.dart';
import 'package:cyberlife/views/pain_map.dart';
import 'package:cyberlife/views/pinky_supination.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  final String title = "Home";

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: title);
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text("Pain Map"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PainMap(key: UniqueKey())));
              },
            ),
            ElevatedButton(
              child: const Text("Joint Motor Function"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const JointMotorFunctionInstructions()));
              },
            ),
            ElevatedButton(
              child: const Text("Open-Close Test"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const OpenClose()));
              },
            ),
            ElevatedButton(
              child: const Text("Pinky Supination Test"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PinkySupination()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
