import 'package:flutter/material.dart';
import 'package:cyberlife/screens/camera_view.dart';

import 'package:cyberlife/widgets/appbar.dart';
import 'package:cyberlife/models/hand_landmarks.dart';

class HandRecognition extends StatefulWidget {
  final String title = "Hand Recognition";

  const HandRecognition({Key? key}) : super(key: key);

  @override
  _HandRecognitionState createState() => _HandRecognitionState();
}

class _HandRecognitionState extends State<HandRecognition> {

  List<double> points = [];
  Image? image;

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: <Widget>[
          CameraView(pointsCallback: pointsCallback, imageCallback: imageCallback),
          //drawDebugPicture(), // debug for printing image
          drawLandmark(),
        ]
      )
    );
  }

  void imageCallback(Image image) {
    setState(() {
      this.image = image;
    });
  }

  void pointsCallback(List<double> points) {
    setState(() {
      this.points = points;
    });
  }

  Widget drawLandmark() {
    return HandLandmarks(landmarkList: points).build();
  }

  Widget drawDebugPicture() {
    if (image == null) {
      return Container();
    }
    return Container(
      child: image!,
    );
  }
}