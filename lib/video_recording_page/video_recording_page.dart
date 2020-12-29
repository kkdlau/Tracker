import 'package:CameraPlus/action_sheet/action_description.dart';
import 'package:CameraPlus/action_sheet/action_sheet.dart';
import 'package:CameraPlus/action_sheet/action_text.dart';
import 'package:CameraPlus/action_video_player/action_video_player.dart';
import 'package:CameraPlus/video_recording_page/recording_button.dart';
import 'package:CameraPlus/video_recording_page/time_count_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
    ]);

    isRecording = false;

    // controller = CameraController(
    //   widget.availableCameras.first,
    //   ResolutionPreset.medium,
    //   enableAudio: true,
    // );
    // _initializeControllerFuture = controller.initialize();
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
          return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller));
        } else {
          return waitingCameraWidget();
        }
      },
    );
  }

  Widget debuggerPlaceholder() {
    return AspectRatio(
        aspectRatio: 3 / 4,
        child: Placeholder(
          color: Colors.white,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(alignment: Alignment.center, children: <Widget>[
        // futureCamera(),
        Positioned(
            bottom: 10.0,
            child: RecordingButton(
              isRecording: isRecording,
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                  if (isRecording) {
                    try {
                      controller.startVideoRecording();
                    } catch (e) {
                      print((e as CameraException).description);
                    }
                  } else {
                    controller.stopVideoRecording().then((XFile v) {
                      print(v.path);
                      getApplicationDocumentsDirectory().then((d) {
                        print(d.path);
                      });
                    });
                  }
                });
              },
            )),
        Positioned(
            top: 10.0,
            child: TimeCountText.fromDuration(Duration(seconds: 10000))),
        ActionVideoPlayer()
      ])),
    );
  }
}
