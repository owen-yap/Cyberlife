import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/tflite/hand_detection.dart';
import 'package:cyberlife/tflite/palm_detection.dart';
import 'package:cyberlife/utilities/isolate_utils.dart';

class CameraView extends StatefulWidget {
  /// Default Constructor

  final Function(List<double> points) pointsCallback;

  final Function(Image image) imageCallback;

  const CameraView({required this.pointsCallback, required this.imageCallback, Key? key}) : super(key: key);



  final String title = "Camera";

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late String err;
  late HandDetection handDetector;
  late PalmDetection palmDetector;
  late IsolateUtils isolateUtils;
  bool processing = false;

  String handleCameraAccessException(String code) {
    switch (code) {
      case 'CameraAccessDenied':
        return 'User denied camera access.';
      case 'CameraAccessDeniedWithoutPrompt':
        return 'User denied camera access.';
      case 'CameraAccessRestricted':
        return 'User restricted camera access.';
      default:
        return 'Another error occurred';
    }
  }

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    isolateUtils = IsolateUtils();
    await isolateUtils.start();
    palmDetector = PalmDetection();
    handDetector = HandDetection();
    initCamera();
  }

  void initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium, enableAudio: false);
    cameraController.initialize().then((_) async {
      await cameraController.startImageStream(onLatestImageAvailable);
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        err = handleCameraAccessException(e.code);
      }
    });
  }

  void onLatestImageAvailable(CameraImage cameraImage) async {
    if (processing || palmDetector.interpreter == null || handDetector.interpreter == null) {
      return;
    }

    setState(() {
      processing = true;
    });

    IsolateData isolateData = IsolateData(
        cameraImage, palmDetector.interpreter!.address,
        handDetector.interpreter!.address);

    List<double> pointList = await inference(isolateData);
    widget.pointsCallback(pointList);

    //debug for printing image
    widget.imageCallback(palmDetector.getPicture(cameraImage));
    await Future.delayed(Duration(milliseconds: 200));

    setState(() {
      processing = false;
    });
  }

  /// Runs inference in another isolate
  Future<List<double>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolateUtils.sendPort
        .send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (!cameraController.value.isInitialized) {
        return Text(err);
      }
    } catch (e) {
      return const Text("Camera Loading!");
    }

    Widget cameraElement = AspectRatio(
      aspectRatio: 1 / cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );

    return cameraElement;
  }
}
