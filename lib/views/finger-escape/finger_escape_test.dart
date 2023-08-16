import 'dart:math';
import 'dart:async';

import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/theme.dart';
import 'package:cyberlife/views/finger-escape/finger_escape_results.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/views/camera_view.dart';

import 'package:cyberlife/models/hand_landmarks.dart';
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utils/hand_gesture_recognition.dart';
import 'package:cyberlife/widgets/appbar.dart';

class FingerEscapeTest extends StatefulWidget {
  final String title = "Grip Release Test";

  final bool showDebugImage = false;
  final bool showLandmarkPoints = false;

  const FingerEscapeTest({Key? key}) : super(key: key);

  @override
  _FingerEscapeTestState createState() => _FingerEscapeTestState();
}

enum HandState { UNSET, OPEN, CLOSE }

class _FingerEscapeTestState extends State<FingerEscapeTest> {
  HandLandmarks? handLandmarks;
  Image? image;
  Gestures? gesture;

  int testTotalTime = 5;

  int timeLeft = 0;
  bool hasStarted = false;
  bool testComplete = false;
  double supinationDegree = 0;
  double maxSupinationDegree = 0;
  AngleList supinationAngleList = AngleList();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);

    return Scaffold(
      appBar: appBar,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
              child: Stack(
                children: <Widget>[
                  CameraView(
                      pointsCallback: pointsCallback,
                      imageCallback: imageCallback),
                  drawDebugPicture(), // debug for printing image
                  drawLandmark(),
                ],
              ),
            ),
            displayHandDetectionStatus(),
            const SizedBox(height: 32),
            generateStats(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              // Set the desired width and height
                              backgroundColor: hasStarted || testComplete
                                  ? const MaterialStatePropertyAll(
                                      AppTheme.lightRed)
                                  : const MaterialStatePropertyAll(
                                      AppTheme.lightGreen),
                            ),
                    onPressed: hasStarted ? endTest : startTest,
                    child: Text(hasStarted
                        ? "Cancel"
                        : testComplete
                            ? "Redo"
                            : "Start"),
                  ),
                ),
                testComplete
                    ? const SizedBox(width: 8)
                    : const SizedBox.shrink(),
                testComplete
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FingerEscapeResults(
                                  supinationAngleList: supinationAngleList,
                                ),
                              ));
                        },
                        child: const Text("Submit"),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const Expanded(child: SizedBox())
          ],
        ),
      )),
    );
  }

  Widget generateStats() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
        children: [
          const Text("Time", style: AppTheme.displaySmall),
          const Text("Left", style: AppTheme.displaySmall),
          const SizedBox(height: 16),
          Text("$timeLeft", style: AppTheme.displayMedium),
        ],
      ),
    ]);
  }

  void startTest() {
    // Defensive call to end test, in case timer is still running
    endTest();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        setState(() {
          endTest();
          testComplete = true;
        });
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });

    hasStarted = true;
    testComplete = false;
    setState(() {
      supinationDegree = 0;
      maxSupinationDegree = 0;
      supinationAngleList = AngleList();
      timeLeft = testTotalTime;
    });
  }

  void endTest() {
    setState(() {
      hasStarted = false;
    });
    timer?.cancel();
  }

  void imageCallback(Image image) {
    setState(() {
      this.image = image;
    });
  }

  void pointsCallback(
      List<double> points, int width, int height, bool handedness) {
    if (!mounted) {
      return;
    }
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
      }
      supinationAngleList.add(supinationDegree);
    });
  }

  void calculateSupination() {
    if (!isHandReady() || !hasStarted) {
      return;
    }

    supinationDegree = handLandmarks!.getPinkySupination();
    maxSupinationDegree = max(supinationDegree, maxSupinationDegree);
  }

  bool isHandReady() {
    if (gesture != Gestures.FOUR && gesture != Gestures.FIVE) {
      return false;
    } else if (!handLandmarks!.areFingersClosed()) {
      return false;
    }
    return true;
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

  Widget displayHandDetectionStatus() {
    Icon isHandDetectedIcon;
    if (gesture == null) {
      isHandDetectedIcon = const Icon(
        Icons.clear,
        size: 50.0, // Adjust the size as needed
        color: AppTheme.lightRed, // Adjust the color as needed
      );
    } else {
      isHandDetectedIcon = const Icon(
        Icons.check,
        size: 50.0, // Adjust the size as needed
        color: AppTheme.lightGreen, // Adjust the color as needed
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Hand detected?"),
        const SizedBox(width: 32),
        isHandDetectedIcon
      ],
    );
  }

  Widget displayFingersClosedStatus() {
    Icon areFingersClosedIcon;
    if (!isHandReady()) {
      areFingersClosedIcon = const Icon(
        Icons.clear,
        size: 50.0, // Adjust the size as needed
        color: AppTheme.lightRed, // Adjust the color as needed
      );
    } else {
      areFingersClosedIcon = const Icon(
        Icons.check,
        size: 50.0, // Adjust the size as needed
        color: AppTheme.lightGreen, // Adjust the color as needed
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Fingers closed?"),
        const SizedBox(width: 32),
        areFingersClosedIcon
      ],
    );
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }
}
