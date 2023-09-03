import 'package:cyberlife/components/time/timer_circle_painter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TimerCircle extends StatefulWidget {
  final bool running;
  final double totalTestTime;
  final double width;
  final double height;
  final void Function(Timer) endTimerCallback;

  const TimerCircle(
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
  Timer? timer;
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
    timer?.cancel();
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
    timer?.cancel();
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
          totalTime: widget.totalTestTime, timeLeft: timeLeft),
      size: Size(widget.width, widget.height),
    );
  }
}