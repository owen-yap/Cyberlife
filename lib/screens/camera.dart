import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cyberlife/widgets/appbar.dart';

class Camera extends StatefulWidget {
  /// Default Constructor
  const Camera({Key? key}) : super(key: key);

  final String title = "Camera";
  //WidgetsFlutterBinding.ensureInitialized();
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  late CameraController controller;
  late List<CameraDescription> _cameras;

  Future<void> initCamera() async {
    _cameras = await availableCameras();
  }

  @override
  void initState() {
    super.initState();
    initCamera().whenComplete(() {
      controller = CameraController(_cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);

    Widget cameraElement = Container();
    try {
      if (controller.value.isInitialized) {
        cameraElement = CameraPreview(controller);
      }
    } catch (e) {
      cameraElement = const Text("Camera not Loaded!");
    }

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: cameraElement
      ),
    );
  }
}
