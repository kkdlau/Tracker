import 'package:CameraPlus/action_sheet/action_description.dart';
import 'package:CameraPlus/action_video_player/action_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

mixin CaptionControlMixin<T extends StatefulWidget> on State<T> {
  int currentCaption = -1;
  bool interrupt = false;
  List<ActionDescription> captionList;
  Widget captionWidget;

  void initializeCaptionMixin(
      List<ActionDescription> captionList, Widget captionWidget) {
    this.captionList = captionList;
    this.captionWidget = captionWidget;
  }

  void scheduleCpation(VideoPlayerController controller) async {
    if (currentCaption + 1 == sheet.actions.length)
      return; // out of bound checking
    final Duration delay =
        captionList[currentCaption + 1].targetTime - controller.value.position;
    await Future.delayed(delay);
    if (interrupt) return; // don't update caption if interrupt flag is raised

    setState(() {
      ++currentCaption;
      captionWidget = captionList[currentCaption].buildCaptionWidget();
    });
    scheduleCpation(controller);
  }
}
