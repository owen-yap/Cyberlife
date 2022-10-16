import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/hand_point.dart';
import 'package:cyberlife/widgets/hand_widget.dart';

class HandLandmarks {

  static const int NUM_OF_VECTORS = 3;
  List<double> landmarkList;
  HandLandmarks({required this.landmarkList});

  Widget build() {
    return HandWidget(points: getPoints());
  }

  List<Widget> getPoints() {
    if (landmarkList.length < 21 * NUM_OF_VECTORS) {
      return [];
    }
    List<Widget> pointList = [];
    for (int i = 0; i < 21; i++) {
      Widget point = HandPoint(x: landmarkList[i * NUM_OF_VECTORS],
          y: landmarkList[i * NUM_OF_VECTORS + 1]);
      pointList.add(point);
    }
    return pointList;
  }
}