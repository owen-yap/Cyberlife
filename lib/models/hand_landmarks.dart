import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/hand_point.dart';
import 'package:cyberlife/widgets/hand_widget.dart';
import 'package:cyberlife/utilities/finger_angle_detection.dart';
import 'package:cyberlife/utilities/hand_gesture_recognition.dart';

class HandLandmarks {

  static const int NUM_OF_VECTORS = 3;
  double scaleFactor;
  bool handedness;
  List<double> landmarkList;
  List<HandPoint> pointList = [];
  HandLandmarks({required this.handedness, required this.landmarkList, required this.scaleFactor}) {
    pointList = getPoints();
  }

  Widget build() {
    return HandWidget(points: pointList);
  }

  bool hasPoints() {
    return landmarkList.isNotEmpty;
  }

  List<HandPoint> getPoints() {
    if (landmarkList.length < 21 * NUM_OF_VECTORS) {
      return [];
    }
    List<HandPoint> tempList = [];
    for (int i = 0; i < 21; i++) {
      HandPoint point = HandPoint(x: landmarkList[i * NUM_OF_VECTORS] * scaleFactor,
          y: landmarkList[i * NUM_OF_VECTORS + 1] * scaleFactor);
      tempList.add(point);
    }
    return tempList;
  }

  Gestures getRecognition() {
    return HandGestureRecognition.getRecognition(pointList, handedness);
  }

  bool areFingersClosed() {
    return FingerAngleDetection.areFingersClosed(pointList);
  }

  double getPinkySupination() {
    return FingerAngleDetection.getPinkySupination(pointList);
  }
}