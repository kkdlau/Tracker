import 'dart:io';

import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/action_video_player/caption_mixin.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

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
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;
  bool loaded = false;
  Future<void> controllerInitializationFuture;
  ActionSheet _sheet;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        subtitleBuilder: (context, text) {
          return null;
        });
    controllerInitializationFuture = videoPlayerController.initialize();
  }

  void playerEventHandler(BetterPlayerEvent e) {}

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
    return Scaffold(
      body: FutureBuilder(
          future: controllerInitializationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container();
            } else {
              return Chewie(controller: chewieController);
            }
          }),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // scheduleDisplayCpation();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
