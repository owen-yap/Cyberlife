import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cyberlife/views/camera_view.dart';

import 'package:cyberlife/models/hand_landmarks.dart';
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utils/hand_gesture_recognition.dart';
import 'package:cyberlife/widgets/appbar.dart';

class PinkySupination extends StatefulWidget {
  final String title = "Pinky Supination Test";

  final bool showDebugImage = false;
  final bool showLandmarkPoints = false;

  const PinkySupination({Key? key}) : super(key: key);

  @override
  _PinkySupinationState createState() => _PinkySupinationState();
}

class _PinkySupinationState extends State<PinkySupination> {
  HandLandmarks? handLandmarks;
  Image? image;
  Gestures? gesture;

  int timeLeft = 0;
  double supinationDegree = 0;
  double maxSupinationDegree = 0;
  bool hasStarted = false;
  String remark = "";
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                CameraView(
                    pointsCallback: pointsCallback,
                    imageCallback: imageCallback),
                drawDebugPicture(), // debug for printing image
                drawLandmark(),
              ],
            ),
            displayGesture(),
            ElevatedButton(
              child: const Text("Start Test"),
              onPressed: startTest,
            ),
            generateStats(),
            gestureRemark(),
          ],
        ),
      ),
    );
  }

  Widget generateStats() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
        child: Column(
          children: [
            const Text("Time Left",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            Text("$timeLeft",
                style: const TextStyle(
                  fontSize: 28,
                )),
          ],
        ),
      ),
      Expanded(
          child: Column(
        children: [
          const Text("Current Supination Degree",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
          Text(supinationDegree.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 28,
              )),
        ],
      )),
      Expanded(
          child: Column(
        children: [
          const Text("Max Supination Degree",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
          Text(maxSupinationDegree.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 28,
              )),
        ],
      )),
    ]);
  }

  Widget gestureRemark() {
    return Center(
      child: Text(remark),
    );
  }

  void startTest() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        setState(() {
          endTest();
        });
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
    hasStarted = true;
    setState(() {
      supinationDegree = 0;
      maxSupinationDegree = 0;
      timeLeft = 20;
    });
  }

  void endTest() {
    hasStarted = false;
    timer!.cancel();
  }

  void imageCallback(Image image) {
    setState(() {
      this.image = image;
    });
  }

  void pointsCallback(
      List<double> points, int width, int height, bool handedness) {
    setState(() {
      handLandmarks = HandLandmarks(
          handedness: handedness,
          landmarkList: points,
          scaleFactor: min(width, height) / HandDetection.IMAGE_SIZE);
      if (handLandmarks!.hasPoints()) {
        gesture = handLandmarks!.getRecognition();
        calculateSupination();
      } else {
        gesture = null;
        remark = "No hand detected for supination test!";
      }
    });
  }

  void calculateSupination() {
    if (gesture != Gestures.FOUR && gesture != Gestures.FIVE) {
      remark = "Improper gesture: need FOUR or FIVE!";
      return;
    }
    if (!handLandmarks!.areFingersClosed()) {
      remark = "Fingers not closed enough!";
      return;
    }
    remark = "OK for supination calculation!";
    if (hasStarted) {
      supinationDegree = handLandmarks!.getPinkySupination();
      maxSupinationDegree = max(supinationDegree, maxSupinationDegree);
    }
  }

  Widget drawLandmark() {
    if (!widget.showLandmarkPoints || handLandmarks == null) {
      return Container();
    }
    return handLandmarks!.build(480, 480);
  }

  Widget drawDebugPicture() {
    if (!widget.showDebugImage || image == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 120.0),
      child: image!,
    );
  }

  Widget displayGesture() {
    if (gesture == null) {
      return const Text("No hand detected!");
    }
    return Text(gesture.toString());
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }
}
