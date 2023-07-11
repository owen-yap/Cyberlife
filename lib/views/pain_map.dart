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

  List<PainStickerList> psLists = [
    PainStickerList(),
    PainStickerList(),
    PainStickerList(),
    PainStickerList()
  ];
  var currTabIndex = 0;

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
                _addSticker(status, psLists[currTabIndex]);
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

  void _addSticker(Status item, PainStickerList psList) {
    setState(() {
      psList.add(item);
    });
  }

  void handleNotification(PainStickerNotification notification) {
    setState(() {
      psLists[currTabIndex].remove(notification.oldPS);
      if (!notification.delete) {
        psLists[currTabIndex].addPS(notification.newPS);
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
            child: Stack(children: <Widget>[
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
                        child: Builder(builder: (BuildContext context) {
                          final TabController controller =
                              DefaultTabController.of(context)!;
                          controller.addListener(() {
                            if (!controller.indexIsChanging) {
                              currTabIndex = controller.index;
                            }
                          });
                          return Scaffold(
                            appBar: const ColoredTabBar(tb: tabBar),
                            body: TabBarView(children: [
                              PainSubmap(
                                  label: 'Front',
                                  psList: psLists[0],
                                  screenshotController: screenshotController),
                              PainSubmap(
                                  label: 'Back',
                                  psList: psLists[1],
                                  screenshotController: screenshotController),
                              PainSubmap(
                                  label: 'Left',
                                  psList: psLists[2],
                                  screenshotController: screenshotController),
                              PainSubmap(
                                  label: 'Right',
                                  psList: psLists[3],
                                  screenshotController: screenshotController)
                            ]),
                          );
                        })),
                  ),
                )
              ]),
          stickerWidgetsPositioned,
          screenshotButton
        ])));
  }
}
