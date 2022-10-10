import 'package:flutter/material.dart';
import 'package:cyberlife/models/pain_sticker_list.dart';
import 'package:screenshot/screenshot.dart';

// ignore: must_be_immutable
class PainSubmap extends StatelessWidget {
  final String label;
  PainStickerList psList;
  ScreenshotController screenshotController;

  PainSubmap({required this.label, required this.psList, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return Stack(children: psList.generateList(label, screenshotController));
  }
}