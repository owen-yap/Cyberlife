import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';

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

  List<Widget> generateList(label) {
    List<Widget> widgetList = <Widget>[];
    label == 'Front'
        ? widgetList.insert(0, frontMap)
        : label == 'Back'
            ? widgetList.insert(0, backMap)
            : label == 'Right'
                ? widgetList.insert(0, rightMap)
                : widgetList.insert(0, leftMap);
    widgetList.insert(0, trash);
    widgetList += psList;
    return widgetList;
  }

  int length() {
    return psList.length;
  }

  void add(Status item, int offset) {
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
