import 'dart:math';
import 'package:cyberlife/components/time/circle_painter.dart';
import 'package:flutter/material.dart';

class StopwatchCirclePainter extends CirclePainter {
  double timeElapsed;
  double totalTime;

  StopwatchCirclePainter({required this.timeElapsed, this.totalTime = 60}) : super(strokeWidth: 10);
  
  @override
  void paint(Canvas canvas, Size size) {
    updateCenterAndRadius(size);
    paintBackground(canvas);

    double timeElapsedFraction = timeElapsed / totalTime;
    double startAngle = -pi/2;
    double progressAngle = 2 * pi * timeElapsedFraction;
    paintProgressArc(canvas, startAngle, progressAngle);

    String timeToDisplay = timeElapsed.toStringAsFixed(1);
    double fontSize = 32;
    paintText(canvas, timeToDisplay, fontSize);
  }
  
  @override
  bool shouldRepaint(StopwatchCirclePainter oldDelegate) {
    double timeElapsedFraction = timeElapsed / totalTime;
    double oldTimeElapsedFraction = oldDelegate.timeElapsed / oldDelegate.totalTime;

    double progressAngle = 2 * pi * (-1 * timeElapsedFraction);
    double oldProgressAngle = 2 * pi * (-1 * oldTimeElapsedFraction);

    return progressAngle != oldProgressAngle; 
  }
}
