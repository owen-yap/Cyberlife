import 'dart:math';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imageLib;

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static imageLib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    imageLib.Image image = imageLib.Image(width: width, height: height);

    for (int w = 0; w < width; w++) {
      for (int h = 0; h < height; h++) {
        final int uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        final rgbValue = ImageUtils.yuv2rgb(y, u, v);

        final x = Platform.isAndroid
            ? h
            : w; // Adjust x-coordinate for rotation on Android

        image = setPixelRgbSafe(image, x, h, rgbValue);
      }
    }

    if (Platform.isAndroid) {
      image = imageLib.copyRotate(image, angle: 90);
    }

    return image;
  }

  static imageLib.Image setPixelRgbSafe(
      imageLib.Image image, int x, int y, int rgbValue) {
    if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
      image.setPixelRgb(
          x, y, getRed(rgbValue), getGreen(rgbValue), getBlue(rgbValue));
    }
    return image;
  }

  static int getRed(int rgbValue) => (rgbValue >> 16) & 0xFF;
  static int getGreen(int rgbValue) => (rgbValue >> 8) & 0xFF;
  static int getBlue(int rgbValue) => rgbValue & 0xFF;

  /// Convert a single YUV pixel to RGB
  static int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  static imageLib.Image squareCropMiddle(imageLib.Image image, int newSide) {
    return imageLib.copyResizeCropSquare(image, size: newSide);
  }

  static imageLib.Image convertCameraImage(CameraImage cameraImage) {
    imageLib.Image image = convertYUV420ToImage(cameraImage);
    int newSide = min(cameraImage.width, cameraImage.height);
    return squareCropMiddle(image, newSide);
  }
}
