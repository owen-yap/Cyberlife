import 'package:cyberlife/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MotorFunctionTestButton extends StatefulWidget {
  final String label;
  final Color? color;
  final Function onPressed;
  final bool isCompleted;

  const MotorFunctionTestButton(
      {Key? key,
      required this.label,
      this.color,
      required this.isCompleted,
      required this.onPressed})
      : super(key: key);

  @override
  _MotorFunctionTestButtonState createState() =>
      _MotorFunctionTestButtonState();
}

class _MotorFunctionTestButtonState extends State<MotorFunctionTestButton> {
  @override
  Widget build(BuildContext context) {
    double circle_radius = 20;

    return ElevatedButton(
      onPressed: () {
        if (kDebugMode) {
          print('${widget.label} button pressed in Joint Motor Function!');
        }
        widget.onPressed();
      },
      style: widget.isCompleted
          ? Theme.of(context).elevatedButtonTheme.style
          : Theme.of(context).elevatedButtonTheme.style!.copyWith(
              backgroundColor: const MaterialStatePropertyAll(Colors.white)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: circle_radius,
          ),
          Text(widget.label),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: circle_radius,
                child: Icon(
                  widget.isCompleted ? Icons.check : Icons.access_time,
                  color: Colors.grey.shade600,
                  size: circle_radius,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: circle_radius,
                child: Icon(
                  Icons.arrow_forward,
                  color: AppTheme.lightGreen,
                  size: circle_radius,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
