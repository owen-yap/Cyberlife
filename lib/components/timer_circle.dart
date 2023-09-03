import 'package:cyberlife/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TimerCircle extends StatefulWidget {
  final bool running;
  double totalTestTime;
  double width;
  double height;
  void Function(Timer) endTimerCallback;

  TimerCircle(
      {super.key,
      required this.running,
      required this.totalTestTime,
      this.width = 50,
      this.height = 50,
      required this.endTimerCallback});

  @override
  _TimerCircleState createState() => _TimerCircleState();
}

class _TimerCircleState extends State<TimerCircle> {
  late Timer timer;
  late double timeLeft;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.totalTestTime;
    if (widget.running) {
      startTimer();
    }
  }

  @override
  void didUpdateWidget(TimerCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.running != oldWidget.running) {
      if (widget.running) {
        startTimer();
      } else {
        resetTimer();
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    int periodInMs = 100;
    double periodInSecs = periodInMs / 1000;

    timer = Timer.periodic(Duration(milliseconds: periodInMs), (timer) {
      if (timeLeft <= 0) {
        widget.endTimerCallback(timer);
        stopTimer();
      } else {
        setState(() {
          timeLeft -= periodInSecs;
        });
      }
    });
  }

  void stopTimer() {
    setState(() {
      timeLeft = 0;
    });
    timer.cancel();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      timeLeft = widget.totalTestTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TimerCirclePainter(
          progress: 1 - timeLeft / widget.totalTestTime, timeLeft: timeLeft),
      size: Size(widget.width, widget.height),
    );
  }
}

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
      -pi / 2,
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
