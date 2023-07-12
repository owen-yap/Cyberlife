import 'package:flutter/material.dart';

class CustomScrollableScaffold extends StatefulWidget {
  final Widget appBar;
  final List<Widget> slivers;

  CustomScrollableScaffold({required this.appBar, required this.slivers});

  @override
  _CustomScrollableScaffoldState createState() =>
      _CustomScrollableScaffoldState();
}

class _CustomScrollableScaffoldState extends State<CustomScrollableScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            toolbarHeight: kToolbarHeight,
            flexibleSpace: widget.appBar,
          ),
          ...widget.slivers,
        ],
      ),
    );
  }
}
