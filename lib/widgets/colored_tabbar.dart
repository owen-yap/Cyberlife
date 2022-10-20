import 'package:flutter/material.dart';

class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tb;

  const ColoredTabBar({super.key, required this.tb});

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.blue, child: tb);
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
