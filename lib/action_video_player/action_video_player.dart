import 'package:CameraPlus/action_sheet/action_description.dart';
import 'package:CameraPlus/action_sheet/action_sheet.dart';
import 'package:CameraPlus/action_video_player/caption_mixin.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/scheduler.dart';

final ActionSheet sheet = ActionSheet(
  actions: <ActionDescription>[
    ActionDescription('TR starts', Duration(seconds: 0), Duration(seconds: 0)),
    ActionDescription(
        'Every action consists of description, target time and time differences',
        Duration(seconds: 2),
        Duration(seconds: -3)),
    ActionDescription(
        'Red / Green text indicate the time differences of previous recording',
        Duration(seconds: 4),
        Duration(seconds: 3))
  ],
);

class ActionVideoPlayer extends StatefulWidget {
  ActionVideoPlayer({Key key}) : super(key: key);

  @override
  _ActionVideoPlayerState createState() => _ActionVideoPlayerState();
}

class _ActionVideoPlayerState extends State<ActionVideoPlayer>
    with
        AfterLayoutMixin<ActionVideoPlayer>,
        CaptionControlMixin<ActionVideoPlayer> {
  VideoPlayerController vController;
  Future<void> controllerInitializationFuture;
  int playedIndex;

  @override
  void initState() {
    super.initState();
    playedIndex = -1;

    initializeCaptionMixin(sheet.actions, Container());

    vController = VideoPlayerController.asset('assets/2020_TR.MOV');
    vController.initialize().then((value) {
      setState(() {
        vController.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Stack(children: <Widget>[
        Center(
          child: AspectRatio(
              aspectRatio: vController.value.aspectRatio,
              child: VideoPlayer(vController)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: captionWidget,
          ),
        )
      ]),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scheduleCpation(vController);
    });
  }
}
