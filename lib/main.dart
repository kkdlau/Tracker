import 'package:CameraPlus/video_recording_page/recording_button.dart';
import 'package:CameraPlus/video_recording_page/time_count_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('camera error' + e.code);
    print(e.description);
  }
  runApp(CameraPlusApp());
}

class CameraPlusApp extends StatefulWidget {
  CameraPlusApp({Key key}) : super(key: key);

  @override
  _CameraPlusAppState createState() => _CameraPlusAppState();
}

class _CameraPlusAppState extends State<CameraPlusApp> {
  CameraController controller;
  Future<void> _initializeControllerFuture;
  bool isRecording;

  @override
  void initState() {
    super.initState();
    isRecording = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // controller = CameraController(cameras.first, ResolutionPreset.high);
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
          return Placeholder(
            fallbackWidth: double.infinity,
          );
        } else {
          return waitingCameraWidget();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.blue),
      title: 'Camera+',
      home: Scaffold(
          // appBar: AppBar(
          //   title: const Text('MaterialApp'),
          // ),
          body: Center(
              child: Stack(alignment: Alignment.center, children: <Widget>[
        AspectRatio(
            aspectRatio: 3 / 4,
            child: Placeholder(
              color: Colors.white,
            )),
        Positioned(
            bottom: 10.0,
            child: RecordingButton(
              isRecording: isRecording,
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
            )),
        Positioned(
            top: 10.0, child: TimeCountText.fromDuration(Duration(seconds: 10)))
      ]))),
    );
  }
}
