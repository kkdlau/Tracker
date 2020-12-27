import 'package:CameraPlus/video_recording_page/recording_button.dart';
import 'package:CameraPlus/video_recording_page/time_count_text.dart';
import 'package:CameraPlus/video_recording_page/video_recording_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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

class CameraPlusApp extends StatelessWidget {
  const CameraPlusApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.blue),
      title: 'Camera+',
      home: VideoRecordingPage(
        availableCameras: cameras,
      ),
    );
  }
}
