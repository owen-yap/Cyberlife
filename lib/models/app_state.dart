import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _changeColor = false;
  get changeColor => _changeColor;
  void toggleColor(bool toggle) {
    _changeColor = toggle;
    notifyListeners();
  }
}
