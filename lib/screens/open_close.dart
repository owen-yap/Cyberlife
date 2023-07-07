import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cyberlife/screens/camera_view.dart';

import 'package:cyberlife/models/hand_landmarks.dart';
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utils/hand_gesture_recognition.dart';
import 'package:cyberlife/widgets/appbar.dart';

class OpenClose extends StatefulWidget {
  final String title = "Open Close Test";

  final bool showDebugImage = false;
  final bool showLandmarkPoints = false;

  const OpenClose({Key? key}) : super(key: key);

  @override
  _OpenCloseState createState() => _OpenCloseState();
}

enum HandState { UNSET, OPEN, CLOSE }

class _OpenCloseState extends State<OpenClose> {
  HandLandmarks? handLandmarks;
  Image? image;
  Gestures? gesture;

  int timeLeft = 0;
  int numOpenClose = 0;
  bool hasStarted = false;
  HandState previousHandState = HandState.UNSET;
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
          const Text("Number of Open Closes",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
          Text("$numOpenClose",
              style: const TextStyle(
                fontSize: 28,
              )),
        ],
      )),
    ]);
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
      numOpenClose = 0;
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
        updateGesture(handLandmarks!.getRecognition());
      } else {
        updateGesture(null);
      }
    });
  }

  void updateGesture(Gestures? newGesture) {
    gesture = newGesture;
    if (!hasStarted) {
      return;
    }

    if (gesture == Gestures.FIST) {
      if (previousHandState == HandState.OPEN) {
        numOpenClose++;
      }
      previousHandState = HandState.CLOSE;
    } else if (gesture == Gestures.FIVE || gesture == Gestures.FOUR) {
      previousHandState = HandState.OPEN;
    }
  }

  Widget drawLandmark() {
    if (!widget.showLandmarkPoints || handLandmarks == null) {
      return Container();
    }
    return handLandmarks!.build();
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
