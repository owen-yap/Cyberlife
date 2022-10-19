import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';
import 'package:screenshot/screenshot.dart';

class PainStickerList {
  double defaultX = 175;
  double defaultY = 175;

  PainStickerList();

  List<Widget> psList = <Widget>[];

  Widget silhouette = Container(
    margin: const EdgeInsets.only(top: 40.0),
    child: Image.asset("assets/images/png/silhouette.png"),
  );

  Widget frontMap = Container(
    margin: const EdgeInsets.only(top: 40.0),
    child: Image.asset("assets/images/png/bodyFront.png"),
  );

  Widget backMap = Container(
    margin: const EdgeInsets.only(top: 40.0),
    child: Image.asset("assets/images/png/bodyBack.png"),
  );

  Widget rightMap = Container(
    margin: const EdgeInsets.only(top: 40.0),
    child: Image.asset("assets/images/png/bodyRight.png"),
  );

  Widget leftMap = Container(
    margin: const EdgeInsets.only(top: 40.0),
    child: Image.asset("assets/images/png/bodyLeft.png"),
  );

  Widget trash = Positioned(
      right: 20,
      top: 20,
      child: Center(
          child: Image.asset("assets/images/png/trash.png", scale: 2.0)));

  List<Widget> generateList(label, ScreenshotController screenshotController) {
    List<Widget> widgetList = <Widget>[];
    switch (label) {
      case 'Front':
        widgetList.insert(0, frontMap);
        break;
      case 'Back':
        widgetList.insert(0, backMap);
        break;
      case 'Right':
        widgetList.insert(0, rightMap);
        break;
      case 'Left':
        widgetList.insert(0, leftMap);
        break;
      default:
        return widgetList;
    }
    widgetList += psList;

    Widget stack = Screenshot(
        controller: screenshotController,
        child: Stack(
          children: widgetList,
        )
    );

    widgetList = <Widget>[];
    widgetList.insert(0, stack);
    widgetList.insert(0, trash);
    return widgetList;
  }

  int length() {
    return psList.length;
  }

  void add(Status item) {
    int offset = psList.length;
    psList.add(PainSticker(
        degree: item,
        draggable: true,
        x: defaultX + offset * 3,
        y: defaultY + offset * 3)
    );
  }

  void addPS(PainSticker ps) {
    psList.add(ps);
  }

  void remove(PainSticker ps) {
    psList.remove(ps);
  }
}
