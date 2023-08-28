import 'package:flutter/material.dart';

class HandWidget extends StatelessWidget {

  final List<Widget> points;
  final double width;
  final double height;
  const HandWidget({Key? key, required this.points, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: points,
      ),
    );
  }
}