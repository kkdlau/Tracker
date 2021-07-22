import 'dart:convert';
import 'dart:io';

import 'package:Tracker/action_sheet/action_description.dart';
import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_text.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ActionVideoPlayer extends StatefulWidget {
  final String videoPath;
  final String sheetPath;
  ActionVideoPlayer({Key key, @required this.videoPath, this.sheetPath})
      : super(key: key);

  @override
  ActionVideoPlayerState createState() => ActionVideoPlayerState();
}

class ActionVideoPlayerState extends State<ActionVideoPlayer> {
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;
  Future<void> controllerInitializationFuture;
  ActionSheet _sheet;

  @override
  void initState() {
    super.initState();
    _sheet = ActionSheet(actions: [
      ActionDescription(
          'lmao', Duration(seconds: 1), Duration(milliseconds: 100))
    ]);

    videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        subtitle: _sheet.toSubtitles(),
        subtitleBuilder: (context, text) {
          // text is in JSON format. For details, please refer to ActionShett.toSubtitles().
          return ActionText.fromAction(
              ActionDescription.fromMap(json.decode(text)));
        });
    controllerInitializationFuture = videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
