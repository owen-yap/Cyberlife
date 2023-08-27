// ignore_for_file: file_names
import 'dart:typed_data';

import 'package:cyberlife/widgets/appbar.dart';
import 'package:cyberlife/widgets/pain_submap.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/providers/pain_sticker_notification.dart';
import 'package:cyberlife/widgets/pain_sticker.dart';
import 'package:cyberlife/models/pain_sticker_list.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class PainMap extends StatefulWidget {
  const PainMap({super.key});

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
  ];

  var currTabIndex = 0;

  static var tabBar = TabBar(
    // give the indicator a decoration (color and border radius)
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(
        25.0,
      ),
      color: Colors.green,
    ),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.black,
    tabs: const [
      Tab(text: "Front"),
      Tab(text: "Back"),
    ],
  );

  late List<Widget> menuItems = Status.values.map((status) {
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

  late Positioned screenshotButton = Positioned(
    right: 0,
    bottom: 40,
    child: IconButton(
      icon: const Icon(Icons.download_rounded),
      iconSize: 48,
      tooltip: 'Save to gallery',
      onPressed: () async {
        final image = await screenshotController.capture();
        if (image == null) return;
        await saveImage(image);
      },
    ),
  );

  late Padding menu = Padding(
    padding: const EdgeInsets.all(16.0),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            25.0,
          ),
          color: Colors.white,
        ),
        child: ListView(scrollDirection: Axis.horizontal, children: menuItems),
      ),
    ),
  );

  late Positioned stickerWidgetsPositioned =
      Positioned(left: 0, bottom: 40, child: Row(children: menuItems));

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
                        length: 2,
                        initialIndex: 0,
                        child: Builder(builder: (BuildContext context) {
                          final TabController controller =
                              DefaultTabController.of(context);

                          controller.addListener(() {
                            if (!controller.indexIsChanging) {
                              currTabIndex = controller.index;
                            }
                          });

                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                      ),
                                      child: tabBar),
                                  Expanded(
                                    child: TabBarView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        PainSubmap(
                                            label: 'Front',
                                            psList: psLists[0],
                                            screenshotController:
                                                screenshotController),
                                        PainSubmap(
                                            label: 'Back',
                                            psList: psLists[1],
                                            screenshotController:
                                                screenshotController),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        })),
                  ),
                )
              ]),
          menu,
          screenshotButton
        ])));
  }
}
