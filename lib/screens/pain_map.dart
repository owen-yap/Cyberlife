// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/providers/pain_sticker_notification.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';
import 'package:cyberlife/models/pain_sticker_list.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class PainMap extends StatefulWidget {
  const PainMap({Key? key}) : super(key: key);

  final String title = "Pain Map";

  @override
  State<PainMap> createState() => _PainMapState();
}

class _PainMapState extends State<PainMap> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

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

  Future<void> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final result = await ImageGallerySaver.saveImage(bytes, name: "PainMap");
    return result['filePath'];
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
                  children: psList.generateList(screenshotController),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                // Bottom Row
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
                            child: const PainSticker(
                                degree: Status.red,
                                scale: 2.0,
                                x: 0,
                                y: 0,
                                draggable: false),
                          )),
                      const Text("Sharp", textAlign: TextAlign.center)
                      // "Neuropathic pain: Sharp, Electric, Shooting, Stabbing"
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
                          child: const PainSticker(
                              degree: Status.green,
                              scale: 2.0,
                              x: 0,
                              y: 0,
                              draggable: false),
                        ),
                      ),
                      const Text("Aching", textAlign: TextAlign.center),
                      // "Musculoskeletal pain"
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_rounded),
                    iconSize: 48,
                    tooltip: 'Save to gallery',
                    onPressed: () async {
                      final image = await screenshotController.capture();
                      if (image == null) return;
                      await saveImage(image);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
