import 'package:cyberlife/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class StopwatchCircle extends StatefulWidget {
  final bool running;
  final double width;
  final double height;

  StopwatchCircle({required this.running, this.width = 200, this.height = 200});

  @override
  _StopwatchCircleState createState() => _StopwatchCircleState();
}

class _StopwatchCircleState extends State<StopwatchCircle> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.running) {
      startStopwatch();
    }
  }

  @override
  void didUpdateWidget(StopwatchCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.running != oldWidget.running) {
      if (widget.running) {
        startStopwatch();
      } else {
        stopStopwatch();
      }
    }
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  void startStopwatch() {
    _stopwatch.reset();
    _stopwatch.start();

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress = (_stopwatch.elapsedMilliseconds / 1000) % 60 / 60;
      });
    });
  }

  void stopStopwatch() {
    setState(() {
      _stopwatch.reset();
      _progress = 0.0;
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StopwatchCirclePainter(progress: _progress),
      size: Size(widget.width, widget.height),
    );
  }
}

class StopwatchCirclePainter extends CustomPainter {
  final double progress;

  StopwatchCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 10.0;
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
    final progressAngle = 2 * pi * progress;
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
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(
      text: "${(progress * 60).toStringAsFixed(1)}s",
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
  bool shouldRepaint(StopwatchCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
