import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';

class PainStickerNotification extends Notification {
  final PainSticker newPS;
  final PainSticker oldPS;
  final bool delete;

  const PainStickerNotification({required this.newPS, required this.oldPS, this.delete = false});
}