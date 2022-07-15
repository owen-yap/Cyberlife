// ignore_for_file: file_names

import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/providers/pain_sticker_notification.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';
import 'package:cyberlife/models/pain_sticker_list.dart';

class PainMap extends StatefulWidget {
  const PainMap({Key? key}) : super(key: key);

  final String title = "Pain Map";

  @override
  State<PainMap> createState() => _PainMapState();
}

class _PainMapState extends State<PainMap> {

  PainStickerList psList = PainStickerList();

  void _addSticker(Status item, int offset) {
    setState(() {
      psList.add(item, offset);
    });
  }

  void handleNotification(PainStickerNotification notification) {
    setState(() {
      psList.remove(notification.oldPS);
      if (!notification.delete) {
        psList.addPS(notification.newPS);
      }
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
              child: NotificationListener<PainStickerNotification>(
                onNotification: (notification) {
                  handleNotification(notification);
                  return true;
                },
                child: Stack(
                  children: psList.generateList(),
                ),
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
                              _addSticker(Status.red, psList.length());
                            },
                            child: const PainSticker(degree: Status.red, scale: 1.0, x: 0, y: 0, draggable: false),
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
                            _addSticker(Status.green, psList.length());
                          },
                          child: const PainSticker(degree: Status.green, scale: 1.0, x: 0, y: 0, draggable: false),
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