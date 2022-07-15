// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:ui';

enum Status {
  red,
  orange,
  yellow,
  green
}

class PainSticker extends StatefulWidget {
  const PainSticker({Key? key, required this.degree, this.scale = 3.0, this.draggable = true, this.appBarHeight = 0}) : super(key: key);

  final Status degree;
  final double scale;
  final bool draggable;
  final double appBarHeight;

  @override
  State<PainSticker> createState() => _PainStickerState();
  String getAsset() {
    String base = "assets/images/png/";
    if (degree == Status.red) { base += "starRed.png"; }
    else if (degree == Status.orange) { base += "starOrange.png"; }
    else if (degree == Status.yellow) { base += "starYellow.png"; }
    else if (degree == Status.green) { base += "starGreen.png"; }

    return base;
  }
}

class _PainStickerState extends State<PainSticker> {

  double _x = 155;
  double _y = 200;
  bool delete = false;

  @override
  Widget build(BuildContext context) {
    if (widget.draggable) {
      return Positioned(
        left: _x,
        top: _y,
        child: Draggable<String>(
          data: 'hi',
          feedback: Center(
            child: Image.asset(widget.getAsset(), scale: widget.scale),
          ),
          childWhenDragging: Container(),
          onDragEnd: (dragDetails) {
            setState(() {
              _x = dragDetails.offset.dx;
              _y = dragDetails.offset.dy - widget.appBarHeight - MediaQueryData.fromWindow(window).padding.top;
              if (_y < 0) { _y = 0; }
              else if (_y > 480) { _y = 480; }
              if (_x > 320 && _y < 30) {
                delete = true;
              }
              //print(_x);
              //print(_y);
              //print(MediaQuery.of(context).viewPadding.top);
            });
          },
          child: Center(
            child: Image.asset(widget.getAsset(), scale: widget.scale),
          ),
        ),
      );
    } else {
      return Center(
        child: Image.asset(widget.getAsset(), scale: widget.scale),
      );
    }
  }
}
