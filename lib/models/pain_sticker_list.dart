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

  Widget trash = Positioned(
      right: 20,
      top: 20,
      child: Center(child: Image.asset("assets/images/png/trash.png", scale: 2.0))
  );

  List<Widget> generateList() {
    List<Widget> widgetList = <Widget>[];
    widgetList.insert(0, silhouette);
    widgetList.insert(0, trash);
    widgetList += psList;
    return widgetList;
  }

  int length() {
    return psList.length;
  }

  void add(Status item, int offset) {
    psList.add(PainSticker(degree: item, draggable: true, x: defaultX + offset * 3, y: defaultY + offset * 3));
  }

  void addPS(PainSticker ps) {
    psList.add(ps);
  }

  void remove(PainSticker ps) {
    psList.remove(ps);
  }
}