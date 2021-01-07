import 'dart:async';

import 'package:CameraPlus/action_sheet/action_sheet.dart';
import 'package:CameraPlus/video_recording_page/bottom_tool_bar.dart';
import 'package:CameraPlus/video_recording_page/camera_viewer.dart';
import 'package:CameraPlus/video_recording_page/time_count_text.dart';
import 'package:CameraPlus/video_recording_page/top_tool_bar.dart';
import 'package:CameraPlus/widgets/hightlighted_container.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

class VideoRecordingPage extends StatefulWidget {
  // Path to action sheet.
  final String actionSheetPath;
  final List<CameraDescription> availableCameras;
  VideoRecordingPage({Key key, this.actionSheetPath, this.availableCameras})
      : super(key: key);

  @override
  _VideoRecordingPageState createState() => _VideoRecordingPageState();
}

class _VideoRecordingPageState extends State<VideoRecordingPage> {
  ActionSheet sheet;
  CameraController controller;
  Future<void> _initializeControllerFuture;
  bool isRecording;
  bool useFlashLight;

  int _camidx;

  @override
  void initState() {
    super.initState();

    _camidx = 0;

    isRecording = false;
    useFlashLight = false;

    controller = CameraController(
      widget.availableCameras[_camidx],
      ResolutionPreset.medium,
      enableAudio: true,
    );
    _initializeControllerFuture = controller.initialize();
  }

  Widget waitingCameraWidget() {
    return Center(
        child: Text('Opening camera...\nPlease allow Camera+ to access camera.',
            textAlign: TextAlign.center));
  }

  Widget futureCamera() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraViewer(controller);
        } else {
          return waitingCameraWidget();
        }
      },
    );
  }

  void onRecordingBtnPressed() {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) {
        try {
          controller.startVideoRecording();
        } catch (e) {
          print((e as CameraException).description);
        }
      } else {
        controller.stopVideoRecording().then((XFile v) {});
      }
    });
  }

  void flashBtnHandler() {
    setState(() {
      useFlashLight = !useFlashLight;
      // todo: enable flash light. (https://pub.dev/packages/lamp)
    });
  }

  void switchCameraHandler() {
    setState(() {
      _camidx = (_camidx + 1) % widget.availableCameras.length;

      controller = CameraController(
        widget.availableCameras[_camidx],
        ResolutionPreset.medium,
        enableAudio: true,
      );
      _initializeControllerFuture = controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(child: futureCamera()),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3),
                    child: HighlightedContainer(
                        highlightedColor: Colors.cyan.withAlpha(100),
                        child: Text(
                          'Selected: Robocon 2021',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline5,
                        )),
                  )),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TopToolBar(
                enableFlash: useFlashLight,
                onFlashBtnPressed: flashBtnHandler,
                onSwitchBtnPressed: switchCameraHandler,
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: TimeCountText.fromDuration(Duration(seconds: 10000))),
            Align(
                alignment: Alignment.bottomCenter,
                child: BottomToolBar(
                  isRecording: isRecording,
                  onRecordingButtonPressed: onRecordingBtnPressed,
                )),
          ]),
    ));
  }
}
