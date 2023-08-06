import 'package:flutter/material.dart';
import 'package:cyberlife/utils/angle_series.dart';
import 'package:cyberlife/widgets/angle_chart.dart';

class AngleList {
  AngleList();
  List<double> angleList = <double>[];
  double minPossibleAngle = -180;
  double maxPossibleAngle = 180;

  void add(double x) {
    angleList.add(x);
  }

  bool isEmpty() {
    return angleList.isEmpty;
  }

  double maxAngle() {
    double res = minPossibleAngle;
    for (double angle in angleList) {
      if (angle > res) {
        res = angle;
      }
    }
    return res;
  }

  double minAngle() {
    double res = maxPossibleAngle;
    for (double angle in angleList) {
      if (angle < res) {
        res = angle;
      }
    }
    return res;
  }

  Widget generateChart() {
    AngleChart chart = AngleChart(generateSeries(angleList));
    return chart;
  }
}
