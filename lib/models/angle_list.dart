import 'package:flutter/material.dart';
import 'package:cyberlife/utilities/angle_series.dart';
import 'package:cyberlife/widgets/angle_chart.dart';

class AngleList {
  AngleList();
  List<double> angleList = <double>[];

  void add(double x) {
    angleList.add(x);
  }

  Widget generateChart() {
    AngleChart chart = AngleChart(generateSeries(angleList));
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: chart,
        ),
    );
  }

}