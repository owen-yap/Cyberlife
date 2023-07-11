import 'dart:io';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FunctionInstructions extends StatefulWidget {
  final String title;
  final String videoPath;
  final StatefulWidget testPage;

  const FunctionInstructions(
      {Key? key,
      required this.title,
      required this.videoPath,
      required this.testPage})
      : super(key: key);

  @override
  _FunctionInstructionsState createState() => _FunctionInstructionsState();
}

class _FunctionInstructionsState extends State<FunctionInstructions> {
  late VideoPlayerController _controller;

  void _initializeVideoPlayer() async {
    await _controller.initialize();
    setState(() {}); // Update the UI to reflect the video initialization
    _controller.play();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar = CommonAppBar(title: widget.title);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'Instructions',
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 32),
              AspectRatio(
                aspectRatio: 16 /
                    9, // Adjust the aspect ratio as per your video's dimensions
                child: VideoPlayer(
                    _controller), // Assuming _controller is already initialized
              ),
              const SizedBox(height: 32),
              Text(
                'Click Start to begin test',
                style: theme.textTheme.displaySmall,
              ),
              const Expanded(
                child: SizedBox(),
              ),
              ElevatedButton(
                child: const Text('Start'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => widget.testPage));
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
