import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';
import 'package:screenshot/screenshot.dart';

class PainStickerList {
  double defaultX = 175;
  double defaultY = 175;

  PainStickerList();

  List<Widget> psList = <Widget>[];

  Widget frontMap = Padding(
    padding: const EdgeInsets.only(top: 24.0),
    child: Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/images/png/dermatome_anterior.png",
        width: 250,
      ),
    ),
  );

  Widget backMap = Padding(
    padding: const EdgeInsets.only(top: 24.0),
    child: Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/images/png/dermatome_posterior.png",
        width: 250,
      ),
    ),
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
      default:
        return widgetList;
    }
    widgetList += psList;

    Widget stack = Screenshot(
        controller: screenshotController,
        child: Stack(
          children: widgetList,
        ));

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
        y: defaultY + offset * 3));
  }

  void addPS(PainSticker ps) {
    psList.add(ps);
  }

  void remove(PainSticker ps) {
    psList.remove(ps);
  }
}
