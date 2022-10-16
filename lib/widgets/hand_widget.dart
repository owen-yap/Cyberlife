import 'package:flutter/material.dart';

class HandWidget extends StatelessWidget {

  final List<Widget> points;
  const HandWidget({Key? key, required this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: points,
    );
  }
}