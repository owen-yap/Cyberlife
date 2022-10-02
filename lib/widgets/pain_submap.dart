import 'package:flutter/material.dart';
import 'package:cyberlife/models/pain_sticker_list.dart';

// ignore: must_be_immutable
class PainSubmap extends StatelessWidget {
  final String label;
  PainStickerList psList;

  PainSubmap({Key? key, required this.label, required this.psList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: psList.generateList(label));
  }
}