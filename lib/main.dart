import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PainMap(title: 'Painmap'),
    );
  }
}

class PainMap extends StatefulWidget {
  const PainMap({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PainMap> createState() => _PainMapState();
}

enum Status {
  red,
  orange,
  yellow,
  green
}

class PainSticker extends StatefulWidget {
  const PainSticker({Key? key, required this.degree, this.x = 0,
    this.y = 0, this.scale = 3.0, this.draggable = true, required this.appBarHeight}) : super(key: key);

  final Status degree;
  final double x;
  final double y;
  final double scale;
  final bool draggable;
  final double appBarHeight;

  @override
  _PainStickerState createState() => _PainStickerState();
  String getAsset() {
    String base = "assets/images/png/";
    if (degree == Status.red) { base += "starRed.png"; }
    else if (degree == Status.orange) { base += "starOrange.png"; }
    else if (degree == Status.yellow) { base += "starYellow.png"; }
    else if (degree == Status.green) { base += "starGreen.png"; }

    return base;
  }


}

class _PainStickerState extends State<PainSticker> {

  double _x = 100;
  double _y = 100;

  @override
  Widget build(BuildContext context) {
    if (widget.draggable) {
      return Positioned(
        left: _x,
        top: _y,
        child: Draggable<String>(
          data: 'hi',
          feedback: Container(
            child: Center(
              child: Image.asset(widget.getAsset(), scale: widget.scale),
            ),
          ),
          childWhenDragging: Container(),
          onDragEnd: (dragDetails) {
            setState(() {
              //print(dragDetails.offset.dy);
              _x = dragDetails.offset.dx;
              _y = dragDetails.offset.dy - widget.appBarHeight - MediaQueryData.fromWindow(window).padding.top;
              if (_y < -20) _y = -20;
              else if (_y > 500) _y = 500;
              //print(MediaQuery.of(context).viewPadding.top);
            });
          },
          child: Container(
            child: Center(
              child: Image.asset(widget.getAsset(), scale: widget.scale),
            ),
          ),
        )
      );
    } else {
      return Container(
        child: Center(
          child: Image.asset(widget.getAsset(), scale: widget.scale),
        ),
      );
    }
  }
}

class _PainMapState extends State<PainMap> {

  List<Widget> widgetList = <Widget>[
    Container(
      margin: const EdgeInsets.only(top: 40.0),
      child: Image.asset("assets/images/png/silhouette.png"),
    )
  ];

  List<Widget> _createChildren() {
    return widgetList;
  }

  void _addSticker(Status item, double height) {

    setState(() {
      widgetList.add(PainSticker(degree: item, draggable: true, appBarHeight: height));
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(widget.title),
    );
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 500,
              height: 500,
              child: Stack(
                children: _createChildren()
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PopupMenuButton<Status>(
        onSelected: (Status item) {
          _addSticker(item, appBar.preferredSize.height);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Status>>[
          PopupMenuItem<Status>(
            value: Status.red,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: PainSticker(degree: Status.red, scale: 1.0, draggable: false, appBarHeight: appBar.preferredSize.height),
            ),
          ),
          PopupMenuItem<Status>(
            value: Status.orange,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: PainSticker(degree: Status.orange, scale: 1.0, draggable: false, appBarHeight: appBar.preferredSize.height),
            ),
          ),
          PopupMenuItem<Status>(
            value: Status.yellow,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: PainSticker(degree: Status.yellow, scale: 1.0, draggable: false, appBarHeight: appBar.preferredSize.height),
            ),
          ),
          PopupMenuItem<Status>(
            value: Status.green,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: PainSticker(degree: Status.green, scale: 1.0, draggable: false, appBarHeight: appBar.preferredSize.height),
            ),
          ),
        ]
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
