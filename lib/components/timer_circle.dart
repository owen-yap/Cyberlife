import 'package:cyberlife/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TimerCirclePainter extends CustomPainter {
  final double progress;
  double timeLeft;

  TimerCirclePainter({required this.progress, required this.timeLeft});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 4.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - strokeWidth / 2;

    // Draw the background circle
    final bgPaint = Paint()
      ..color = AppTheme.lightGreen.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw the progress arc
    final progressPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final progressAngle = 2 * pi * (progress - 1);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      - pi / 2,
      progressAngle,
      false,
      progressPaint,
    );

    // Draw the elapsed time label
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    timeLeft = timeLeft < 0 ? 0 : timeLeft;
    final textSpan = TextSpan(
      text: timeLeft.toStringAsFixed(1),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(TimerCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
