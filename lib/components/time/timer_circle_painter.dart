import 'dart:math';
import 'package:cyberlife/components/time/circle_painter.dart';
import 'package:flutter/material.dart';

class TimerCirclePainter extends CirclePainter {
  double timeLeft;
  double totalTime;

  TimerCirclePainter({required this.timeLeft, required this.totalTime}) : super(strokeWidth: 4);
  
  @override
  void paint(Canvas canvas, Size size) {
    updateCenterAndRadius(size);
    paintBackground(canvas);

    timeLeft = timeLeft < 0 ? 0 : timeLeft;
    double timeLeftFraction = timeLeft / totalTime;
    double startAngle = -pi/2;
    double progressAngle = 2 * pi * (-1 * timeLeftFraction);
    paintProgressArc(canvas, startAngle, progressAngle);

    String timeToDisplay = timeLeft.toStringAsFixed(1);
    double fontSize = 16;
    paintText(canvas, timeToDisplay, fontSize);
  }
  
  @override
  bool shouldRepaint(TimerCirclePainter oldDelegate) {
    double timeLeftFraction = timeLeft / totalTime;
    double oldTimeLeftFraction = oldDelegate.timeLeft / oldDelegate.totalTime;

    double progressAngle = 2 * pi * (-1 * timeLeftFraction);
    double oldProgressAngle = 2 * pi * (-1 * oldTimeLeftFraction);

    return progressAngle != oldProgressAngle; 
  }
}
