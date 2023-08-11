import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imageLib;
import 'package:cyberlife/tflite/hand_detection_model.dart';
import 'package:cyberlife/utils/image_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Manages separate Isolate instance for inference
class IsolateUtils {
  static const String DEBUG_NAME = "InferenceIsolate";

  late Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    // Receives stream of data from main port and processes it
    // Performs inference
    await for (final IsolateData isolateData in port) {
      if (isolateData != null) {
        HandDetection handDetector = HandDetection.fromInterpreter(
            interpreter:
                Interpreter.fromAddress(isolateData.handInterpreterAddress));

        imageLib.Image image =
            ImageUtils.convertCameraImage(isolateData.cameraImage);

        Map<String, dynamic> results = await handDetector.predict(image);
        isolateData.responsePort!.send(results);
      }
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int handInterpreterAddress;
  SendPort? responsePort;

  IsolateData(
    this.cameraImage,
    this.handInterpreterAddress,
  );
}
