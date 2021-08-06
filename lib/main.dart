import 'package:Tracker/theme_notifier.dart';
import 'package:Tracker/utils.dart';
import 'package:Tracker/video_recording/video_recording_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Guideline.loadInstructions(INSTRUCTION_PATH);

  // SystemChrome.setEnabledSystemUIOverlays([]);

  await Utils.initialize();

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
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeNotifier(),
      child: Builder(
        builder: (BuildContext context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.grey[100],
                brightness: Brightness.light,
                visualDensity: VisualDensity.adaptivePlatformDensity),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.grey[900],
                scaffoldBackgroundColor: Colors.grey[900]),
            themeMode: Provider.of<ThemeNotifier>(context).mode,
            title: 'Tracker',
            home: VideoRecordingPage(availableCameras: cameras)),
      ),
    );
  }
}
