// ignore_for_file: file_names
import 'dart:typed_data';

import 'package:cyberlife/widgets/appbar.dart';
import 'package:cyberlife/widgets/colored_tabbar.dart';
import 'package:cyberlife/widgets/pain_submap.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/providers/pain_sticker_notification.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';
import 'package:cyberlife/models/pain_sticker_list.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class PainMap extends StatefulWidget {
  PainMap({Key? key}) : super(key: key);

  final String title = "Pain Map";

  @override
  State<PainMap> createState() => _PainMapState();
}

class _PainMapState extends State<PainMap> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  PainStickerList psList = PainStickerList();
  static const tabBar = TabBar(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.white,
    tabs: [
      Tab(text: "Front"),
      Tab(text: "Back"),
      Tab(text: "Side (L)"),
      Tab(text: "Side (R)"),
    ],
  );

  late List<Widget> stickerWidgets = Status.values.map((status) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                _addSticker(status, psList.length());
              },
              child: PainSticker(
                  degree: status, scale: 4.0, x: 0, y: 0, draggable: false),
            )),
        Text(status.name, textAlign: TextAlign.center)
        // "Neuropathic pain: Sharp, Electric, Shooting, Stabbing"
      ],
    );
  }).toList();

  late Positioned stickerWidgetsPositioned = Positioned(
      left: 0,
      top: 40,
      child: Column(
        children: stickerWidgets,
      ));

  late Positioned screenshotButton = Positioned(
      right: 5,
      bottom: 10,
      child: IconButton(
        icon: const Icon(Icons.download_rounded),
        iconSize: 48,
        tooltip: 'Save to gallery',
        onPressed: () async {
          final image = await screenshotController.capture();
          if (image == null) return;
          await saveImage(image);
        },
      ));

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
            child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: NotificationListener<PainStickerNotification>(
                          onNotification: (notification) {
                            handleNotification(notification);
                            return true;
                          },
                          child: DefaultTabController(
                              length: 4,
                              initialIndex: 0,
                              child: Scaffold(
                                  appBar: const ColoredTabBar(tb: tabBar),
                                  body: TabBarView(children: [
                                    PainSubmap(
                                        label: 'Front',
                                        psList: psList,
                                        screenshotController: screenshotController),
                                    PainSubmap(
                                        label: 'Back',
                                        psList: psList,
                                        screenshotController: screenshotController),
                                    PainSubmap(
                                        label: 'Left',
                                        psList: psList,
                                        screenshotController: screenshotController),
                                    PainSubmap(
                                        label: 'Right',
                                        psList: psList,
                                        screenshotController: screenshotController)
                                  ]))),
                        ),
                    )
                  ]),
                  stickerWidgetsPositioned,
                  screenshotButton
                ])));
  }
}
