import 'dart:async';
import 'dart:io';

import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/recording_manager/recording_manager_page.dart';
import 'package:Tracker/setting/setting_page.dart';
import 'package:Tracker/sheet_manager/sheet_magaer_page.dart';
import 'package:Tracker/utils.dart';
import 'package:Tracker/video_recording/bottom_tool_bar.dart';
import 'package:Tracker/video_recording/camera_config.dart';
import 'package:Tracker/video_recording/camera_viewer.dart';
import 'package:Tracker/video_recording/time_count_text.dart';
import 'package:Tracker/video_recording/top_tool_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../define.dart';

// final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

class VideoRecordingPage extends StatefulWidget {
  final List<CameraDescription> availableCameras;
  VideoRecordingPage({Key key, this.availableCameras}) : super(key: key);

  @override
  VideoRecordingPageState createState() => VideoRecordingPageState();
}

class VideoRecordingPageState extends State<VideoRecordingPage> {
  File selectedFile;
  CameraController controller;
  CameraConfiguration config;
  Future<void> _initializeControllerFuture;
  bool isRecording;
  ActionSheet selectedSheet;
  GlobalKey<ScaffoldState> _scaffoldNode;

  @override
  void initState() {
    super.initState();

    config = CameraConfiguration(
        cameraIndex: 0, enableFlash: false, enableAudio: true);

    isRecording = false;

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    initializeCamera();

    _scaffoldNode = GlobalKey<ScaffoldState>();
  }

  void initializeCamera() {
    controller = CameraController(
      widget.availableCameras[config.cameraIndex],
      ResolutionPreset.medium,
      enableAudio: config.enableAudio,
    );
    _initializeControllerFuture = controller.initialize();
  }

  Widget waitingCameraWidget() {
    return Center(
        child: Text('Opening camera...\nPlease allow Camera+ to access camera.',
            textAlign: TextAlign.center));
  }

  Widget cameraPreview() {
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
        controller.stopVideoRecording().then((XFile f) {
          Utils.getDocumentRootPath().then((root) {
            final String fileAlias = f.path.split('/').last;
            File(f.path).copy('$root/$RECORDING_DIR' + fileAlias);
          });
        });
      }
    });
  }

  void flashBtnHandler() {
    setState(() {
      config.enableFlash = !config.enableFlash;
      // todo: enable flash light. (https://pub.dev/packages/lamp)
    });
  }

  void switchCameraHandler() {
    setState(() {
      config.cameraIndex =
          (config.cameraIndex + 1) % widget.availableCameras.length;

      controller = CameraController(
        widget.availableCameras[config.cameraIndex],
        ResolutionPreset.medium,
        enableAudio: true,
      );
      _initializeControllerFuture = controller.initialize();
    });
  }

  void openSheetManager() {
    controller.dispose();
    Navigator.push<File>(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return SheetManagerPage();
    })).then((f) => setState(() {
          initializeCamera();
          if (f != null) {
            updateSelectedSheet(f);
          }
        }));
  }

  void updateSelectedSheet(File f) {
    selectedFile = f;
    selectedSheet =
        ActionSheetDecoder.getInstance().decode(f.readAsStringSync());
  }

  void openRecordingManager() {
    controller.dispose();

    Navigator.push(
            context, MaterialPageRoute(builder: (_) => RecordingManagerPage()))
        .then((_) {
      setState(() {
        initializeCamera();
      });
    });
  }

  void openSetting() {
    // controller.dispose();
    // Navigator.push(context, MaterialPageRoute(builder: (_) => SettingPage()))
    //     .then((value) {
    //   setState(() {
    //     initializeCamera();
    //   });
    // });

    _scaffoldNode.currentState.showSnackBar(SnackBar(
      content: Container(
        //color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 75),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Yay! A SnackBar!'),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 1000,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldNode,
        body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return SafeArea(
              child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: <Widget>[
                    cameraPreview(),
                    TopToolBar(
                      orientation: orientation,
                      enableFlash: config.enableFlash,
                      onFlashBtnPressed: flashBtnHandler,
                      onSwitchBtnPressed: switchCameraHandler,
                      onSettingBtnPressed: openSetting,
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: TimeCountText.fromDuration(
                                Duration(seconds: 10000)))),
                    BottomToolBar(
                        orientation: orientation,
                        isRecording: isRecording,
                        onDocumentButtonPressed: openSheetManager,
                        onRecordingButtonPressed: onRecordingBtnPressed,
                        onMovieButtonPressed: openRecordingManager),
                  ]),
            );
          },
        ));
  }
}
