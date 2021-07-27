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
import 'package:Tracker/widgets/hightlighted_container.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_controller/torch_controller.dart';
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
  Future<void> _initializeCameraFuture;
  TorchController torch;
  bool isRecording;
  ActionSheet selectedSheet;
  DateTime recordingStartTime;
  DateTime currentRecordingTime;
  Timer updateBadgeTimer;
  Widget cameraWidget;

  @override
  void initState() {
    super.initState();

    config = CameraConfiguration(
        cameraIndex: 0, enableFlash: false, enableAudio: true);

    isRecording = false;

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    _initializeCameraFuture = initializeCamera();
    buildCameraPreview();
  }

  /// Initialize the camera according to [config].
  ///
  /// some initialization invokes calling platform-specific methods and thereby this function has to be a async function.
  Future<void> initializeCamera() async {
    controller = CameraController(
      widget.availableCameras[config.cameraIndex],
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: config.enableAudio,
    );

    torch = TorchController();
    if (await torch.hasTorch) {
      torch.initialize(intensity: 0.5);
    }

    await controller.initialize();
  }

  Widget waitingCameraWidget() {
    return Center(
        child: Text('Opening camera...\nPlease allow Camera+ to access camera.',
            textAlign: TextAlign.center));
  }

  void buildCameraPreview() {
    if (controller == null || _initializeCameraFuture == null) {
      /**
       * while this page is not on screen (i.e. the user jumps to other pages),
       * this page will dispose the camera temporarily to avoid the camera keeps opening.
       * 
       * However, Flutter still renders this page whatever any setState() is called,
       * and cause the camera widget to rebuild.
       * 
       * Hence we need to put a empty widget for handling this case.
       */
      cameraWidget = SizedBox();
    } else {
      cameraWidget = FutureBuilder(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraViewer(controller, scaleCallback: (details) {
              if (details.pointerCount == 1)
                return; // don't handle if only a finger is used

              // !todo: implement camera scaling
            });
          } else {
            return waitingCameraWidget();
          }
        },
      );
    }
  }

  void onRecordingBtnPressed() {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) {
        try {
          // controller.startVideoRecording();
          recordingStartTime = DateTime.now();
          currentRecordingTime = recordingStartTime;

          updateBadgeTimer =
              Timer.periodic(Duration(seconds: 1), updateCurrentRecordingTime);
        } catch (e) {
          print((e as CameraException).description);
        }
      } else {
        updateBadgeTimer?.cancel();
        return;
        controller.stopVideoRecording().then((XFile f) {
          Utils.getDocumentRootPath().then((root) {
            final String fileAlias = f.path.split('/').last;
            File(f.path).copy('$root/$RECORDING_DIR' + fileAlias);
          });
        });
      }
    });
  }

  void updateCurrentRecordingTime(_) {
    setState(() {
      currentRecordingTime = DateTime.now();
    });
  }

  void flashBtnHandler() {
    setState(() {
      config.enableFlash = !config.enableFlash;
      torch.toggle();
    });
  }

  void switchCameraHandler() {
    disposeCamera().then((value) => setState(() {
          nextCamera();
          _initializeCameraFuture =
              initializeCamera(); // reinitialize after switching to new camera
          buildCameraPreview();
        }));
  }

  void nextCamera() {
    config.cameraIndex =
        (config.cameraIndex + 1) % widget.availableCameras.length;
  }

  void openSheetManager() async {
    await disposeCamera();
    Navigator.push<File>(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return SheetManagerPage();
    })).then((f) => setState(() {
          _initializeCameraFuture = initializeCamera();
          buildCameraPreview();
          if (f != null) {
            updateSelectedSheet(f);
          }
        }));
  }

  void updateSelectedSheet(File f) {
    selectedFile = f;
    selectedSheet = ActionSheetDecoder.getInstance().decode(f);
  }

  void openRecordingManager() async {
    await disposeCamera();

    Navigator.push(
            context, MaterialPageRoute(builder: (_) => RecordingManagerPage()))
        .then((_) {
      setState(() {
        _initializeCameraFuture = initializeCamera();
        buildCameraPreview();
      });
    });
  }

  Future<void> disposeCamera() async {
    if (config.enableFlash) torch.toggle();
    await controller.dispose();
    setState(() {
      controller = null;
      _initializeCameraFuture = null;
      cameraWidget = SizedBox.shrink();
    });
  }

  String badgeContent() {
    if (isRecording) {
      return Utils.formatDuration(
          currentRecordingTime.difference(recordingStartTime));
    } else if (selectedSheet != null) {
      return selectedSheet.sheetName;
    } else
      return "";
  }

  void openSetting() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
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
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void saveStamp() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: UnconstrainedBox(
            alignment: Alignment.bottomLeft,
            constrainedAxis: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('+1s'),
              ),
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(child: cameraWidget),
              SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: !isRecording
                      ? TopToolBar(
                          orientation: orientation,
                          enableFlash: config.enableFlash,
                          onFlashBtnPressed: flashBtnHandler,
                          onSwitchBtnPressed: switchCameraHandler,
                          onSettingBtnPressed: openSetting,
                        )
                      : SizedBox.shrink(),
                ),
              ),
              AnimatedOpacity(
                opacity: (selectedSheet != null || isRecording) ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: SafeArea(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.5),
                            child: HighlightedContainer(
                              highlightedColor: isRecording
                                  ? Colors.red.withAlpha(150)
                                  : null,
                              child: Text(
                                badgeContent(),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ))),
                ),
              ),
              SafeArea(
                bottom: false,
                child: BottomToolBar(
                    orientation: orientation,
                    isRecording: isRecording,
                    onDocumentButtonPressed: openSheetManager,
                    onRecordingButtonPressed: onRecordingBtnPressed,
                    onMovieButtonPressed: openRecordingManager,
                    onStampButtonPressed: saveStamp),
              ),
            ]);
      },
    ));
  }
}
