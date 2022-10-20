import 'package:flutter/material.dart';

class HandWidget extends StatelessWidget {

  final List<Widget> points;
  const HandWidget({Key? key, required this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: points,
      ),
      height: 480,
      width: 480,
    );
  }
}