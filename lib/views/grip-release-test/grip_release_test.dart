import 'dart:math';
import 'dart:async';

import 'package:cyberlife/theme.dart';
import 'package:cyberlife/views/grip-release-test/grip_release_results.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/views/camera_view.dart';

import 'package:cyberlife/models/hand_landmarks.dart';
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utils/hand_gesture_recognition.dart';
import 'package:cyberlife/widgets/appbar.dart';

class GripReleaseTest extends StatefulWidget {
  final String title = "Grip Release Test";

  final bool showDebugImage = false;
  final bool showLandmarkPoints = false;

  const GripReleaseTest({Key? key}) : super(key: key);

  @override
  _GripReleaseTestState createState() => _GripReleaseTestState();
}

enum HandState { UNSET, OPEN, CLOSE }

class _GripReleaseTestState extends State<GripReleaseTest> {
  HandLandmarks? handLandmarks;
  Image? image;
  Gestures? gesture;

  int test_total_time = 10;

  int timeLeft = 0;
  int numOpenClose = 0;
  bool hasStarted = false;
  bool testComplete = false;
  HandState previousHandState = HandState.UNSET;
  Timer? timer;

  final GlobalKey _stackKey = GlobalKey(debugLabel: "grip_release_camera_view_stack");

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
                                builder: (context) => GripReleaseResults(
                                  fistsMade: numOpenClose,
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
      Column(
        children: [
          const Text("Number of", style: AppTheme.displaySmall),
          const Text("Fists Made", style: AppTheme.displaySmall),
          const SizedBox(height: 16),
          Text("$numOpenClose", style: AppTheme.displayMedium),
        ],
      ),
    ]);
  }

  void startTest() {
    // Defensive call to end test, in case timr is still running
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
      numOpenClose = 0;
      timeLeft = test_total_time;
    });
  }

  void endTest() {
    setState(() {
      hasStarted = false;
    });
    timer?.cancel();
  }

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

    final RenderBox renderBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackWidth = renderBox.size.width;
    final stackHeight = renderBox.size.height;

    setState(() {
      handLandmarks = HandLandmarks(
          handedness: handedness,
          landmarkList: points,
          scaleFactor: min(stackWidth, stackHeight) / HandDetection.IMAGE_SIZE);
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

    final RenderBox renderBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackWidth = renderBox.size.width;
    final stackHeight = renderBox.size.height;

    return handLandmarks!.build(stackWidth, stackHeight);
  }

  Widget drawDebugPicture() {
    if (!widget.showDebugImage || image == null) {
      return Container();
    }

    final RenderBox renderBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackWidth = renderBox.size.width;
    final stackHeight = renderBox.size.height;

    return Container(
      width: stackWidth,
      height: stackHeight,
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
    Icon isHandDetected;
    if (gesture == null) {
      isHandDetected = const Icon(
        Icons.clear,
        size: 50.0, // Adjust the size as needed
        color: AppTheme.lightRed, // Adjust the color as needed
      );
    } else {
      isHandDetected = const Icon(
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
        isHandDetected
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
