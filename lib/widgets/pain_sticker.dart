// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cyberlife/providers/pain_sticker_notification.dart';
import 'dart:ui';

enum Status {
  red,
  orange,
  yellow,
  green
}

class PainSticker extends StatelessWidget {
  const PainSticker({Key? key, required this.degree, required this.x , required this.y, this.scale = 3.0, this.draggable = true}) : super(key: key);

  final Status degree;
  final double scale;
  final bool draggable;
  final double x;
  final double y;

  String getAsset() {
    String base = "assets/images/png/";
    if (degree == Status.red) { base += "starRed.png"; }
    else if (degree == Status.orange) { base += "starOrange.png"; }
    else if (degree == Status.yellow) { base += "starYellow.png"; }
    else if (degree == Status.green) { base += "starGreen.png"; }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;

    if (draggable) {
      return Positioned(
        left: x,
        top: y,
        child: Draggable<String>(
          data: 'hi',
          feedback: Center(
            child: Image.asset(getAsset(), scale: scale),
          ),
          childWhenDragging: Container(),
          onDragEnd: (dragDetails) {
              double _x = dragDetails.offset.dx;
              double _y = dragDetails.offset.dy - appBarHeight - MediaQueryData.fromWindow(window).padding.top;
              if (_y < 0) { _y = 0; }
              else if (_y > 480) { _y = 480; }

              PainSticker newPS = PainSticker(degree: degree, scale: scale, draggable: true, x: _x, y: _y);

              if (_x > 320 && _y < 30) {
                PainStickerNotification(newPS: newPS, oldPS: this, delete: true).dispatch(context);
              } else {
                PainStickerNotification(newPS: newPS, oldPS: this).dispatch(context);
              }
          },
          child: Center(
            child: Image.asset(getAsset(), scale: scale),
          ),
        ),
      );
    } else {
      return Center(
        child: Image.asset(getAsset(), scale: scale),
      );
    }
  }
}

