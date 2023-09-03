import 'dart:math';
import 'dart:async';

import 'package:cyberlife/components/time/timer_circle.dart';
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
  final String title = "Finger Escape Test";

  final bool showDebugImage = false;
  final bool showLandmarkPoints = false;

  const FingerEscapeTest({Key? key}) : super(key: key);

  @override
  _FingerEscapeTestState createState() => _FingerEscapeTestState();
}

class _FingerEscapeTestState extends State<FingerEscapeTest> {
  HandLandmarks? handLandmarks;
  Image? image;
  Gestures? gesture;

  double totalTestTime = 10;

  bool hasStarted = false;
  bool testComplete = false;
  double supinationDegree = 0;
  double maxSupinationDegree = 0;
  AngleList supinationAngleList = AngleList();

  final GlobalKey _stackKey =
      GlobalKey(debugLabel: "finger_escape_camera_view_stack");

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Retrieve the width and height of the Stack using the key
                    return Stack(
                      key: _stackKey,
                      children: <Widget>[
                        CameraView(
                          pointsCallback: pointsCallback,
                          imageCallback: imageCallback,
                        ),
                        drawDebugPicture(), // debug for printing image
                        drawLandmark(),
                      ],
                    );
                  },
                )),
            displayHandDetectionStatus(),
            const SizedBox(height: 8),
            displayFingersClosedStatus(),
            const SizedBox(height: 16),
            displayTestStatus(),
            const SizedBox(height: 40),
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
                    onPressed: hasStarted ? cancelTest : startTest,
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

  // UI Functions -----------------------------------------------------------------------------------------

  Widget displayTestStatus() {
    bool shouldTimerRun = hasStarted && !testComplete;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      const Column(
        children: [
          Text("Time", style: AppTheme.displaySmall),
          Text("Left", style: AppTheme.displaySmall),
        ],
      ),
      TimerCircle(
        running: shouldTimerRun,
        totalTestTime: totalTestTime,
        endTimerCallback: completeTestTimerCallback,
      )
    ]);
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

  // Logic Functions -----------------------------------------------------------------------------------------

  void startTest() {
    setState(() {
      supinationDegree = 0;
      maxSupinationDegree = 0;
      supinationAngleList = AngleList();
      hasStarted = true;
      testComplete = false;
    });
  }

  void completeTestTimerCallback(Timer timer) {
    setState(() {
      hasStarted = false;
      testComplete = true;
    });
  }

  void cancelTest() {
    setState(() {
      supinationDegree = 0;
      maxSupinationDegree = 0;
      supinationAngleList = AngleList();
      hasStarted = false;
      testComplete = false;
    });
  }

  // Camera View Callbacks -----------------------------------------------------------------------------------------

  void imageCallback(Image image) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.image = image;
    });
  }

  void pointsCallback(
      List<double> points, int width, int height, bool handedness) {
    if (!mounted) {
      return;
    }

    final RenderBox renderBox =
        _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackWidth = renderBox.size.width;
    final stackHeight = renderBox.size.height;

    setState(() {
      handLandmarks = HandLandmarks(
          handedness: handedness,
          landmarkList: points,
          scaleFactor: min(stackWidth, stackHeight) / HandDetection.IMAGE_SIZE);
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

  // Debug UI Functions ------------------------------------------------------------------------------------------

  Widget drawLandmark() {
    if (!widget.showLandmarkPoints || handLandmarks == null) {
      return Container();
    }

    final RenderBox renderBox =
        _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackWidth = renderBox.size.width;
    final stackHeight = renderBox.size.height;

    return handLandmarks!.build(stackWidth, stackHeight);
  }

  Widget drawDebugPicture() {
    if (!widget.showDebugImage || image == null) {
      return Container();
    }

    final RenderBox renderBox =
        _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackWidth = renderBox.size.width;
    final stackHeight = renderBox.size.height;

    return Container(
      width: stackWidth,
      height: stackHeight,
      child: image!,
    );
  }
}
