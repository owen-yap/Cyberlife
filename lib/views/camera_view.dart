import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:cyberlife/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utils/isolate_utils.dart';
import 'package:image/image.dart' as imageLib;



class CameraView extends StatefulWidget {
  /// Default Constructor

  final Function(List<double> points, int width, int height, bool handedness)
      pointsCallback;

  final Function(Image image) imageCallback;

  const CameraView(
      {required this.pointsCallback, required this.imageCallback, Key? key})
      : super(key: key);

  final String title = "Camera";

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late String err;
  late HandDetection handDetector;
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
    WidgetsBinding.instance.addObserver(this);
    isolateUtils = IsolateUtils();
    await isolateUtils.start();
    handDetector = HandDetection();
    initCamera();
  }

  void initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium,
        enableAudio: false);
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
    if (processing || handDetector.interpreter == null || !mounted) {
      return;
    }


    setState(() {
      processing = true;
    });

    IsolateData isolateData =
        IsolateData(cameraImage, handDetector.interpreter!.address);

    Map<String, dynamic> results = await inference(isolateData);
    List<double> pointList = (results.isNotEmpty) ? results["landmarks"] : [];
    bool handedness = (results.isNotEmpty) ? results["handedness"] > 0.5 : true;
    widget.pointsCallback(
        pointList, cameraImage.width, cameraImage.height, handedness);

    //debug for printing image

    imageLib.Image debugImage = ImageUtils.convertCameraImage(cameraImage);
    // debugImage = imageLib.copyResizeCropSquare(debugImage, size:224);
    widget.imageCallback(Image.memory(
        imageLib.encodeJpg(debugImage)));

    await Future.delayed(Duration(milliseconds: 66));

    // Prevents setState after dispose is called
    if (!mounted) {
      return;
    }

    setState(() {
      processing = false;
    });
  }


  /// Runs inference in another isolate
  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolateUtils.sendPort
        .send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      aspectRatio: 1,
      child: ClipRect(
        child: Transform.scale(
          scale: cameraController.value.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1 / cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
            ),
          ),
        ),
      ),
    );

    return cameraElement;
  }
}
