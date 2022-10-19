import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cyberlife/screens/camera_view.dart';

import 'package:cyberlife/models/hand_landmarks.dart';
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utilities/hand_gesture_recognition.dart';
import 'package:cyberlife/widgets/appbar.dart';

class HandRecognition extends StatefulWidget {
  final String title = "Hand Recognition";

  const HandRecognition({Key? key}) : super(key: key);

  @override
  _HandRecognitionState createState() => _HandRecognitionState();
}

class _HandRecognitionState extends State<HandRecognition> {

  HandLandmarks? handLandmarks;
  Image? image;
  Gestures? gesture;

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
                CameraView(pointsCallback: pointsCallback, imageCallback: imageCallback),
                //drawDebugPicture(), // debug for printing image
                drawLandmark(),
              ],
            ),
          displayGesture(),
          ],
        ),
      ),
    );
  }

  void imageCallback(Image image) {
    setState(() {
      this.image = image;
    });
  }

  void pointsCallback(List<double> points, int width, int height, bool handedness) {
    setState(() {
      handLandmarks = HandLandmarks(handedness: handedness, landmarkList: points,
          scaleFactor: min(width, height) / HandDetection.IMAGE_SIZE);
    });
  }

  Widget drawLandmark() {
    if (handLandmarks == null || !handLandmarks!.hasPoints()) {
      gesture = null;
      return Container();
    }
    gesture = handLandmarks!.getRecognition();
    return handLandmarks!.build();
  }

  Widget drawDebugPicture() {
    if (image == null) {
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
}