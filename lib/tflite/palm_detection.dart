import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imageLib;
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:cyberlife/utilities/image_utils.dart';

class PalmDetection {
  static const String MODEL_FILE_NAME = "palm_detection_full.tflite";
  static const int IMAGE_SIZE = 192;
  static const double THRESHOLD = 0.1;

  bool enableThreshold = false;

  List<List<int>> _outputShapes = [];
  List<TfLiteType> _outputTypes = [];

  late ImageProcessor imageProcessor;
  Interpreter? interpreter;

  PalmDetection() {
    loadModel(interpreter);
    loadImageProcessor();
  }

  PalmDetection.fromInterpreter({required Interpreter this.interpreter}) {
    loadModel(interpreter);
    loadImageProcessor();
  }

  void loadImageProcessor() {
    imageProcessor = ImageProcessorBuilder()
    //.add(ResizeOp(IMAGE_SIZE, IMAGE_SIZE, ResizeMethod.NEAREST_NEIGHBOUR))
    //.add(ResizeWithCropOrPadOp(IMAGE_SIZE, IMAGE_SIZE))
        .build();
  }

  void loadModel(Interpreter? interpreter) async {

    if (interpreter != null) {
      loadTensors();
      return;
    }

    try {
      this.interpreter = await Interpreter.fromAsset(MODEL_FILE_NAME,
        options: InterpreterOptions()..threads = 4,
      );
      await loadTensors();

    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  Future<void> loadTensors() async {
    var outputTensors = interpreter!.getOutputTensors();

    print(outputTensors);

    outputTensors.forEach((tensor) {
      _outputShapes.add(tensor.shape);
      _outputTypes.add(tensor.type);
    });
  }

  TensorImage processImage(imageLib.Image image) {
    imageLib.Image resizedImage = imageLib.copyResizeCropSquare(image, IMAGE_SIZE);
    TensorImage inputImage = TensorImage(TfLiteType.float32);
    inputImage.loadImage(resizedImage);
    return imageProcessor.process(inputImage);
  }

  Image getPicture(CameraImage cameraImage) {
    TensorImage image = processImage(
        ImageUtils.convertCameraImage(cameraImage));
    return Image.memory(imageLib.encodeJpg(image.image) as Uint8List);
  }

  Future<List<double>> predict(imageLib.Image image) async {

    if (interpreter == null) {
      print("Interpreter not initialized");
      return [];
    }

    TensorImage inputImage = processImage(image);

    // Load TensorBuffers for output tensors
    TensorBuffer outputScreenLandmarks = TensorBuffer.createFixedSize(_outputShapes[0], _outputTypes[0]);

    List<Object> inputs = [inputImage.buffer];

    Map<int, Object> outputs = {
      0: outputScreenLandmarks.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    print(outputScreenLandmarks.getDoubleList());

    /*if (enableThreshold && outputScore.getDoubleValue(0) < THRESHOLD) {
      return [];
    }*/

    return outputScreenLandmarks.getDoubleList();
  }
}