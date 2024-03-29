import 'dart:async';
import 'dart:io';

import 'package:Tracker/action_sheet/action_description.dart';
import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/action_video_player/caption.dart';
import 'package:Tracker/recording_manager/recording_manager_page.dart';
import 'package:Tracker/setting/option_setting.dart';
import 'package:Tracker/setting/setting_page.dart';
import 'package:Tracker/sheet_manager/sheet_magaer_page.dart';
import 'package:Tracker/utils.dart';
import 'package:Tracker/video_recording/bottom_tool_bar.dart';
import 'package:Tracker/camera/camera_config.dart';
import 'package:Tracker/camera/camera_viewer.dart';
import 'package:Tracker/video_recording/top_tool_bar.dart';
import 'package:Tracker/widgets/hightlighted_container.dart';
import 'package:Tracker/widgets/messanger.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../define.dart';

// final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

class VideoRecordingPage extends StatefulWidget {
  static const List<DeviceOrientation> perferedOrientations = [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ];

  final List<CameraDescription> availableCameras;
  VideoRecordingPage({Key key, this.availableCameras}) : super(key: key);

  @override
  VideoRecordingPageState createState() => VideoRecordingPageState();
}

class VideoRecordingPageState extends State<VideoRecordingPage> {
  CameraController controller; // camera controller
  CameraConfiguration config; // camera configuration
  Future<void> _initializeCameraFuture;
  bool isRecording;
  File selectedFile;
  ActionSheet selectedSheet;
  ActionSheet tmpSheet;
  int recordedStamp; // count of recorded stamp, should not exceed the length of [selectedSheet]'s actions
  DateTime recordingStartTime;
  Timer updateBadgeTimer;
  Widget cameraWidget;
  Orientation
      lastUpdatedOrientation; // for locking orientation during recording
  GlobalKey<MessengerState> messengerController;

  @override
  void initState() {
    super.initState();

    recordedStamp = 0;
    messengerController = GlobalKey();

    config = CameraConfiguration(
        cameraIndex: 0, enableFlash: false, enableAudio: true);

    isRecording = false;

    SystemChrome.setPreferredOrientations(
        VideoRecordingPage.perferedOrientations);

    _initializeCameraFuture = initializeCamera();
    buildCameraPreview();
  }

  /// Initialize the camera according to [config].
  ///
  /// some initialization invokes calling platform-specific methods and thereby this function has to be a async function.
  Future<void> initializeCamera() async {
    int index = OptionSetting.CAMERA_QUALITY.options
        .indexOf(OptionSetting.CAMERA_QUALITY.savedValue);

    controller = CameraController(
      widget.availableCameras[config.cameraIndex],
      ResolutionPreset.values[index],
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: config.enableAudio,
    );

    await controller.initialize();

    setFlash();
  }

  Widget waitingCameraWidget(
      {String caption =
          'Opening camera...\nPlease allow Tracker to access camera.'}) {
    return Center(child: Text(caption, textAlign: TextAlign.center));
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
            return CameraViewer(controller);
          } else if (snapshot.hasError) {
            return waitingCameraWidget(
                caption:
                    'Unable to open camera, please switch to different cameras, or relaunch Tracker.\n Error message: ' +
                        snapshot.error.toString());
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
          controller.startVideoRecording();
          lockOrientation(lastUpdatedOrientation);
          recordingStartTime = DateTime.now();
          recordedStamp = 0;
          tmpSheet = ActionSheet();
          messengerShowNextStamp();

          updateBadgeTimer =
              Timer.periodic(Duration(seconds: 1), updateCurrentRecordingTime);
        } catch (e) {
          print((e as CameraException).description);
        }
      } else {
        updateBadgeTimer?.cancel();
        messengerController.currentState.hideMessage();

        controller.stopVideoRecording().then((XFile f) {
          releaseOrientation();
          Utils.getDocumentRootPath().then((root) {
            final String fileAliasWithExtension = f.path.split('/').last;
            File(f.path).copy('$root/$RECORDING_DIR' + fileAliasWithExtension);
            if (selectedSheet != null) {
              tmpSheet.linked = true;
              tmpSheet.sheetName =
                  fileAliasWithExtension.split('.').first; // remove extension
              tmpSheet.saveTo('$root/$ACTION_SHEET_DIR' +
                  tmpSheet.sheetName +
                  ACTION_SHEET_FILE_EXTENSION);
            }
          });
        });
      }
    });
  }

  void messengerShowNextStamp() {
    ActionDescription act = this.nextStampContent;
    if (act.isEmpty) {
      messengerController.currentState.hideMessage();
    } else {
      messengerController.currentState.showMessage(act.description);
    }
  }

  void updateCurrentRecordingTime(_) {
    setState(() {
      badgeContent(); // dummy function call
    });
  }

  void flashBtnHandler() {
    setState(() {
      config.enableFlash = !config.enableFlash;
    });
    setFlash();
  }

  void setFlash() {
    final FlashMode mode = config.enableFlash ? FlashMode.torch : FlashMode.off;
    controller.setFlashMode(mode).catchError((e) {
      print(e.toString());
      setState(() {
        config.enableFlash = !config.enableFlash;
      }); // if there is any error, go back to previous status
    });
  }

  void switchCameraHandler() {
    disposeCamera(disposeInNextFrame: false).then((value) => setState(() {
          config.enableFlash = false;
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
          } else if (selectedFile != null && !selectedFile.existsSync()) {
            setState(() {
              selectedFile = null;
              selectedSheet = null;
            });
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

  Future<void> disposeCamera({bool disposeInNextFrame = true}) async {
    setState(() {
      _initializeCameraFuture = null;
      cameraWidget = SizedBox.shrink();
    });
    if (disposeInNextFrame) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.dispose().then((value) {
          controller = null;
        });
      });
    } else {
      await controller.dispose();
      controller = null;
    }
  }

  Duration get recordingDuration {
    return isRecording
        ? DateTime.now().difference(recordingStartTime)
        : Duration.zero;
  }

  String badgeContent() {
    if (isRecording) {
      // print recording duration is prioritized
      return Utils.formatDuration(recordingDuration);
    } else if (selectedSheet != null) {
      // print selected sheet
      return selectedSheet.sheetName;
    } else
      return "";
  }

  void openSetting() async {
    await disposeCamera();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SettingPage();
    })).then((value) {
      setState(() {
        _initializeCameraFuture = initializeCamera();
        buildCameraPreview();
      });
    });
  }

  ActionDescription get nextStampContent {
    if (recordedStamp >= selectedSheet.actions.length)
      return ActionDescription.emptyTemplate();
    else
      return selectedSheet.actions[recordedStamp];
  }

  void saveStamp() {
    if (recordedStamp >= selectedSheet.actions.length)
      return; // no more stamps for recording

    final ActionDescription act = this.nextStampContent.clone();
    Duration d = recordingDuration;
    act.timeDiff = d - act.targetTime;
    tmpSheet.actions.add(act);
    recordedStamp++;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: UnconstrainedBox(
            alignment: Alignment.bottomLeft,
            constrainedAxis: Axis.vertical,
            child: Caption.fromAction(act)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
    }
    setState(() {
      messengerShowNextStamp();
    });
  }

  bool hasStampToMark() {
    return selectedSheet != null &&
        selectedSheet.actions.length > 0 &&
        recordedStamp < selectedSheet.actions.length;
  }

  void lockOrientation(Orientation orienation) {
    switch (orienation) {
      case Orientation.portrait:
        {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
        break;
      case Orientation.landscape:
        {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]);
        }
        break;

      default:
        throw Exception(
            'lockOrientation: unhandled case ' + orienation.toString());
    }

    controller.lockCaptureOrientation();
  }

  void releaseOrientation() {
    SystemChrome.setPreferredOrientations(
        VideoRecordingPage.perferedOrientations);
    controller.unlockCaptureOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        lastUpdatedOrientation = orientation;
        return Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(child: cameraWidget),
              Messenger(key: messengerController),
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
                  )),
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
                                    MediaQuery.of(context).size.width * 0.4),
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
                    stampCount: recordedStamp,
                    onDocumentButtonPressed: openSheetManager,
                    onRecordingButtonPressed: onRecordingBtnPressed,
                    onMovieButtonPressed: openRecordingManager,
                    onStampButtonPressed: hasStampToMark() ? saveStamp : null),
              ),
            ]);
      },
    ));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}
