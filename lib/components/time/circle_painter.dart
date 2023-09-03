import 'dart:math';
import 'package:cyberlife/theme.dart';
import 'package:flutter/material.dart';

abstract class CirclePainter extends CustomPainter {
  double strokeWidth;

  Offset center = Offset.zero;
  double radius = double.nan;

  CirclePainter({this.strokeWidth = 10});

  void updateCenterAndRadius(Size size) {
    center = Offset(size.width / 2, size.height / 2);
    radius = min(size.width / 2, size.height / 2) - strokeWidth / 2;
  }

  void paintBackground(Canvas canvas) {
    // Draw the background circle
    Paint bgPaint = Paint()
      ..color = AppTheme.lightGreen.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);
  }

  void paintProgressArc(Canvas canvas, double startAngle, double sweepAngle) {
    // Draw the progress arc
    Paint progressPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  void paintText(Canvas canvas, String timeToDisplay, double fontSize) {
    // Draw the elapsed time label
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    TextSpan textSpan = TextSpan(
      text: timeToDisplay,
      style: textStyle,
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    Offset textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }
}
