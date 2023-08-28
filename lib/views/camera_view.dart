import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utils/isolate_utils.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as p;


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

  img.Image convertCameraImage(CameraImage cameraImage) {
  // Convert CameraImage to Image using the image package
  // You might need to handle different formats (YUV, BGRA, etc.)
  // This example assumes the image is in the BGRA8888 format
  ImageFormat format = cameraImage.format;

  print('Image format: $format');
  final img.Image result_img = img.Image.fromBytes(
    width: cameraImage.width,
    height: cameraImage.height,
    bytes: cameraImage.planes[0].bytes.buffer,
    format: img.Format.float64
  );
  return result_img;
}

// Future<String> saveImageLocally(img.Image image) async {
//   final Directory appDirectory = await getApplicationDocumentsDirectory();
//   final String imagePath = p.join(appDirectory.path, 'image_${DateTime.now()}.jpg');

//   // Encode the image as JPEG and save it to the file
//   final List<int> jpeg = img.encodeJpg(image);
//   await File(imagePath).writeAsBytes(jpeg);

//   return imagePath;
// }

void saveImageLocally(img.Image image) async {
  ImagePicker().pickImage(source: ImageSource.camera)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {

        GallerySaver.saveImage(recordedImage.path).then((String path) {
          print(path);
        });
      }
    });
}

  void onLatestImageAvailable(CameraImage cameraImage) async {
    if (processing || handDetector.interpreter == null || !mounted) {
      return;
    }

    final img.Image image = convertCameraImage(cameraImage);
    saveImageLocally(image);

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

    /*imageLib.Image debugImage = ImageUtils.convertCameraImage(cameraImage);
    //debugImage = imageLib.copyResizeCropSquare(debugImage, 224);
    widget.imageCallback(Image.memory(
        imageLib.encodeJpg(debugImage) as Uint8List));*/

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
