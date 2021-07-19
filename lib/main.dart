import 'package:Tracker/recording_manager/recording_manager_page.dart';
import 'package:Tracker/video_recording_page/video_recording_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setEnabledSystemUIOverlays([]);

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('camera error' + e.code);
    print(e.description);
  }
  runApp(TrackerApp());
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        title: 'Tracker',
        home: RecordingManagerPage());
  }
}
