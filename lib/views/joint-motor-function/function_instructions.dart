import 'dart:async';
import 'package:cyberlife/models/joint_motor_function_user_state.dart';
import 'package:cyberlife/theme.dart';
import 'package:cyberlife/widgets/appbar.dart';
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
  bool _isVideoInitialized = false;
  Timer _timer = Timer(const Duration(seconds: 0), () {});
  bool _isVideoButtonVisible = true;
  int videoButtonVisibleDuration = 5;
  double aspectRatio = 16 / 9;

  void _initializeVideoPlayer() async {
    _controller.initialize();
    setState(() {
      _isVideoInitialized = true;
    }); // Update the UI to reflect the video initialization
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: videoButtonVisibleDuration), () {
      setState(() {
        _isVideoButtonVisible = false;
      });
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _isVideoButtonVisible = true;
    });
    _startTimer();
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
              const Expanded(
                child: SizedBox(),
              ),
              Text(
                '${widget.title} Test',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Instructions',
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  _resetTimer();
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    _isVideoInitialized
                        ? AspectRatio(
                            aspectRatio:
                                aspectRatio, // Adjust the aspect ratio as per your video's dimensions
                            child: VideoPlayer(
                                _controller), // Assuming _controller is already initialized
                          )
                        : const CircularProgressIndicator(),
                    AnimatedOpacity(
                      opacity: _isVideoButtonVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeIn,
                      child: Visibility(
                        visible: _isVideoButtonVisible,
                        child: SizedBox(
                          width: 110.0,
                          height: 80.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              _resetTimer();
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            backgroundColor:
                                AppTheme.lightGreen.withOpacity(0.7),
                            splashColor: Colors.transparent,
                            // Increase the size of the green circle
                            // by adjusting the size property of the FloatingActionButton
                            // and the width and height of the SizedBox
                            // that wraps the FloatingActionButton
                            // Modify these values according to your preference
                            // to achieve the desired size
                            mini: false,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                  Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget.testPage));
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
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
