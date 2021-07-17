import 'dart:io';

import 'package:Tracker/action_sheet/action_description.dart';
import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/action_video_player/caption_mixin.dart';
import 'package:Tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';

class ActionVideoPlayer extends StatefulWidget {
  final String videoPath;
  final String sheetPath;
  ActionVideoPlayer({Key key, @required this.videoPath, this.sheetPath})
      : super(key: key);

  @override
  ActionVideoPlayerState createState() => ActionVideoPlayerState();
}

class ActionVideoPlayerState extends State<ActionVideoPlayer>
    with
        AfterLayoutMixin<ActionVideoPlayer>,
        CaptionSchedularMixin<ActionVideoPlayer> {
  BetterPlayerController bpController;
  bool loaded = false;
  Future<String> controllerInitializationFuture;
  double _captionPadding = 20.0;
  ActionSheet _sheet;

  @override
  void initState() {
    super.initState();

    setState(() {
      bpController = BetterPlayerController(
          BetterPlayerConfiguration(
            deviceOrientationsOnFullScreen: DeviceOrientation.values,
            controlsConfiguration:
                BetterPlayerControlsConfiguration(enableOverflowMenu: false),
            fit: BoxFit.contain,
            autoPlay: true,
            fullScreenByDefault: true,
          ),
          betterPlayerDataSource: BetterPlayerDataSource(
              BetterPlayerDataSourceType.file, widget.videoPath));

      if (widget.sheetPath != null) {
        _sheet = ActionSheetDecoder.getInstance()
            .decode(File(widget.sheetPath).readAsStringSync());
      } else
        _sheet = ActionSheet();

      schedularInitialize(_sheet.actions, Container(), bpController);
      bpController.addEventsListener((e) {
        if (e.betterPlayerEventType == BetterPlayerEventType.initialized) {
          setState(() {
            loaded = true;
            scheduleDisplayCpation();
            startScheduleCaption();
          });
        }
      });

      bpController.addEventsListener(playerEventHandler);
    });
  }

  void playerEventHandler(BetterPlayerEvent e) {
    print(e.betterPlayerEventType);
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
    scheduleDisplayCpation();
  }
}
