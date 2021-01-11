import 'package:CameraPlus/action_sheet/action_description.dart';
import 'package:CameraPlus/action_sheet/action_sheet.dart';
import 'package:CameraPlus/action_video_player/caption_mixin.dart';
import 'package:CameraPlus/utils.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:better_player/better_player.dart';

final ActionSheet sheet = ActionSheet(
  actions: <ActionDescription>[
    ActionDescription('Test message: Game start.', Duration(seconds: 0),
        Duration(seconds: 0)),
    ActionDescription(
        'Every action consists of description, target time and time differences',
        Duration(seconds: 3),
        Duration(seconds: -3)),
    ActionDescription(
        'Red / Green text indicate the time differences of previous recording',
        Duration(seconds: 7),
        Duration(seconds: 3)),
    ActionDescription(
        'The display time of a caption is automatically calculated.',
        Duration(seconds: 11),
        Duration(seconds: 1))
  ],
);

class ActionVideoPlayer extends StatefulWidget {
  final String videoPath;
  ActionVideoPlayer({Key key, @required this.videoPath}) : super(key: key);

  @override
  _ActionVideoPlayerState createState() => _ActionVideoPlayerState();
}

class _ActionVideoPlayerState extends State<ActionVideoPlayer>
    with
        AfterLayoutMixin<ActionVideoPlayer>,
        CaptionSchedularMixin<ActionVideoPlayer> {
  BetterPlayerController bpController;
  bool loaded = false;
  Future<String> controllerInitializationFuture;
  double _captionPadding = 20.0;

  @override
  void initState() {
    super.initState();

    Utils.getFileUrl(
            'camera/videos/CAP_2F505A82-36EC-4EC5-8795-E24B9E1AB0B1.mp4')
        .then((value) {
      setState(() {
        bpController = BetterPlayerController(
            BetterPlayerConfiguration(
              autoPlay: true,
              fullScreenByDefault: true,
            ),
            betterPlayerDataSource:
                BetterPlayerDataSource(BetterPlayerDataSourceType.file, value));
        schedularInitialize(sheet.actions, Container(), bpController);
        bpController.addEventsListener((e) {
          if (e.betterPlayerEventType == BetterPlayerEventType.initialized) {
            bpController.setOverriddenAspectRatio(
                bpController.videoPlayerController.value.aspectRatio);
            setState(() {
              loaded = true;
              scheduleDisplayCpation(bpController);
              startScheduleCaption();
            });
          }
        });

        bpController.addEventsListener(playerEventHandler);
      });
    });
  }

  void playerEventHandler(BetterPlayerEvent e) {
    switch (e.betterPlayerEventType) {
      case BetterPlayerEventType.controlsHidden:
        setState(() {
          _captionPadding = 20.0;
        });
        break;
      case BetterPlayerEventType.controlsVisible:
        setState(() {
          _captionPadding = 60.0;
        });
        break;
      default:
    }
  }

  Widget animatedCpationWidget(double padding) {
    return Positioned.fill(
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: padding),
        duration: const Duration(milliseconds: 100),
        child: Align(alignment: Alignment.bottomCenter, child: captionWidget),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Center(
          child: loaded
              ? BetterPlayer(
                  controller: bpController,
                  overlayWidget: animatedCpationWidget(_captionPadding))
              : Container())
    ]);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // scheduleDisplayCpation(bpController);
  }
}
