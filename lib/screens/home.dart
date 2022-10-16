// ignore_for_file: file_names

import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/screens/pain_map.dart';
import 'package:cyberlife/screens/joint_motor_function.dart';
import 'package:cyberlife/screens/hand_recognition.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
                  context, MaterialPageRoute(builder: (context) => const PainMap())
                );
              },
            ),
            ElevatedButton(
              child: const Text("Joint Motor Function"),
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const JointMotorFunction())
                );
              },
            ),
            ElevatedButton(
              child: const Text("Hand Recognition"),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const HandRecognition())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}