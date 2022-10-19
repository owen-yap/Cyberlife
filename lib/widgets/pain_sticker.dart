// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cyberlife/providers/pain_sticker_notification.dart';
import 'dart:ui';

enum Status {
  pain,
  numb,
  pins,
  misc
}

class PainModal extends StatefulWidget {
  const PainModal({super.key});

  @override
  State<StatefulWidget> createState() => PainModalState();

}

class PainModalState extends State<PainModal> {
  double painLevel = 0;
  @override
  Widget build(BuildContext context) {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(20.0)),
            child: Container(
            constraints: const BoxConstraints(maxHeight: 350),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(value: painLevel, max: 10, divisions: 10, label: painLevel.round().toString(),
      onChanged: (double value) {
        setState(() {
          painLevel = value;
        });
      })]))));
  }

}
class PainSticker extends StatelessWidget {
  const PainSticker({Key? key, required this.degree, required this.x , required this.y, this.scale = 5.0, this.draggable = true}) : super(key: key);

  final Status degree;
  final double scale;
  final bool draggable;
  final double x;
  final double y;

  String getAsset() {
    String base = "assets/images/png/";
    if (degree == Status.pain) { base += "painSticker.png"; }
    else if (degree == Status.numb) { base += "numbSticker.png"; }
    else if (degree == Status.pins) { base += "pinsSticker.png"; }
    else if (degree == Status.misc) { base += "miscSticker.png"; }

    return base;
  }
  
  _showStickerModal(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PainModal();
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double tabBarHeight = const TabBar(
      tabs: [
        Tab(text: "dummy text"),
      ],
    ).preferredSize.height;

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
              double _y = dragDetails.offset.dy - appBarHeight - tabBarHeight - MediaQueryData.fromWindow(window).padding.top;
              double width = MediaQuery.of(context).size.width;
              
              if (_y < 0) { _y = 0; }
              else if (_y > 480) { _y = 480; }

              PainSticker newPS = PainSticker(degree: degree, scale: scale, draggable: true, x: _x, y: _y);

              if (_x > width - 60 && _y < 60) {
                PainStickerNotification(newPS: newPS, oldPS: this, delete: true).dispatch(context);
              } else {
                PainStickerNotification(newPS: newPS, oldPS: this).dispatch(context);
              }

              _showStickerModal(context);
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

