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
  const PainSticker({Key? key, required this.degree, this.scale = 3.0, this.draggable = true, this.appBarHeight = 0}) : super(key: key);

  final Status degree;
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

  double _x = 155;
  double _y = 200;
  bool delete = false;

  @override
  Widget build(BuildContext context) {
    if (widget.draggable) {
      return Positioned(
        left: _x,
        top: _y,
        child: Draggable<String>(
          data: 'hi',
          feedback: Center(
            child: Image.asset(widget.getAsset(), scale: widget.scale),
          ),
          childWhenDragging: Container(),
          onDragEnd: (dragDetails) {
            setState(() {
              _x = dragDetails.offset.dx;
              _y = dragDetails.offset.dy - widget.appBarHeight - MediaQueryData.fromWindow(window).padding.top;
              if (_y < 0) { _y = 0; }
              else if (_y > 480) { _y = 480; }
              if (_x > 320 && _y < 30) {
                delete = true;
              }
              //print(_x);
              //print(_y);
              //print(MediaQuery.of(context).viewPadding.top);
            });
          },
          child: Center(
            child: Image.asset(widget.getAsset(), scale: widget.scale),
          ),
        ),
      );
    } else {
      return Center(
          child: Image.asset(widget.getAsset(), scale: widget.scale),
      );
    }
  }
}

class _PainMapState extends State<PainMap> {


  List<Widget> widgetList = <Widget>[
    Container(
      margin: const EdgeInsets.only(top: 40.0),
      child: Image.asset("assets/images/png/silhouette.png"),
    ),
    Positioned(
      right: 20,
      top: 20,
      child: Center(child: Image.asset("assets/images/png/trash.png", scale: 2.0))
    )
  ];

  List<Widget> _createChildren() {
    for (var item in widgetList) {
      print(item);
      if (item is PainSticker) {
        PainSticker cur =  item as PainSticker;
      }
    }
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
            Expanded(
              child: Stack(
                children: _createChildren()
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row( // Bottom Row
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            _addSticker(Status.red, appBar.preferredSize.height);
                          },
                          child: const PainSticker(degree: Status.red, scale: 1.0, draggable: false),
                        )
                      ),
                      const Text("Sharp, Electric Pain", textAlign: TextAlign.center) // "Neuropathic pain: Sharp, Electric, Shooting, Stabbing"
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            _addSticker(Status.green, appBar.preferredSize.height);
                          },
                          child: const PainSticker(degree: Status.green, scale: 1.0, draggable: false),
                        ),
                      ),
                      const Text("Aching, Throbbing Pain", textAlign: TextAlign.center), // "Musculoskeletal pain"
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /* floatingActionButton: PopupMenuButton<Status>(
        onSelected: (Status item) {
          _addSticker(item, appBar.preferredSize.height);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Status>>[
          PopupMenuItem<Status>(
            value: Status.red,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: PainSticker(degree: Status.red, scale: 1.0, draggable: false, appBarHeight: appBar.preferredSize.height),
                ),
                const Text("Sharp, Electric Pain", textAlign: TextAlign.center)], // "Neuropathic pain: Sharp, Electric, Shooting, Stabbing"
            ),
          ),
          PopupMenuItem<Status>(
            value: Status.green,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: PainSticker(degree: Status.green, scale: 1.0, draggable: false, appBarHeight: appBar.preferredSize.height),
                ),
                const Text("Aching, Throbbing Pain", textAlign: TextAlign.center)], // "Musculoskeletal pain"
            ),
          ),
        ]
      ), // This trailing comma makes auto-formatting nicer for build methods. */
    );
  }
}
