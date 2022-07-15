// ignore_for_file: file_names

import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';

class PainMap extends StatefulWidget {
  const PainMap({Key? key}) : super(key: key);

  final String title = "Pain Map";

  @override
  State<PainMap> createState() => _PainMapState();
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
      //print(item);
      if (item is PainSticker) {
        PainSticker cur =  item;
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
    CommonAppBar appBar = CommonAppBar(title: widget.title);
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