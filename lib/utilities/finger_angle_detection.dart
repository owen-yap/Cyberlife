import 'dart:math';

import 'package:cyberlife/widgets/hand_point.dart';

class FingerAngleDetection {

  static double thresholdAngle = 10;

  static double getAngle(double p1X, double p1Y, double p2X, double p2Y) {
    double dx = p1X - p2X;
    double dy = p1Y - p2Y;
    return atan2(dy, dx) * (180 / pi);
  }

  static double firstFingerAngle(List<HandPoint> landmarks) =>
      getAngle(landmarks[6].x, landmarks[6].y, landmarks[8].x, landmarks[8].y);

  static double secondFingerAngle(List<HandPoint> landmarks) =>
      getAngle(landmarks[10].x, landmarks[10].y, landmarks[12].x, landmarks[12].y);

  static double thirdFingerAngle(List<HandPoint> landmarks) =>
      getAngle(landmarks[14].x, landmarks[14].y, landmarks[16].x, landmarks[16].y);

  static double fourthFingerAngle(List<HandPoint> landmarks) =>
      getAngle(landmarks[18].x, landmarks[18].y, landmarks[20].x, landmarks[20].y);


  static bool areFingersClosed(List<HandPoint> landmarks) {
    double firstAngle = firstFingerAngle(landmarks);
    double secondAngle = secondFingerAngle(landmarks);
    double thirdAngle = thirdFingerAngle(landmarks);

    if ((firstAngle - secondAngle).abs() > thresholdAngle || (secondAngle - thirdAngle).abs() > thresholdAngle) {
      return false;
    } else {
      return true;
    }
  }

  static double getPinkySupination(List<HandPoint> landmarks) {
    return (thirdFingerAngle(landmarks) - fourthFingerAngle(landmarks)).abs();
  }
}
