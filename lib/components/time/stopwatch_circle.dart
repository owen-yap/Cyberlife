import 'package:cyberlife/components/time/stopwatch_circle_painter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchCircle extends StatefulWidget {
  final bool running;
  final double width;
  final double height;

  const StopwatchCircle({super.key, required this.running, this.width = 200, this.height = 200});

  @override
  _StopwatchCircleState createState() => _StopwatchCircleState();
}

class _StopwatchCircleState extends State<StopwatchCircle> {
  final Stopwatch _stopwatch = Stopwatch();

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
    super.dispose();
  }

  void startStopwatch() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void stopStopwatch() {
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    double timeElapsed = (_stopwatch.elapsedMilliseconds / 1000) % 60;
    return CustomPaint(
      painter: StopwatchCirclePainter(timeElapsed: timeElapsed),
      size: Size(widget.width, widget.height),
    );
  }
}
