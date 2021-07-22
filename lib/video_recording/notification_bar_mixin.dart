import 'package:Tracker/video_recording/video_recording_page.dart';
import 'package:Tracker/widgets/hightlighted_container.dart';
import 'package:flutter/material.dart';

mixin NotificationBarMixin on State<VideoRecordingPage> {
  bool _display = false;
  Widget _displayContent;
  Animation<double> _animationController;

  void pushNotification(Widget content,
      {Duration displayTime = const Duration(seconds: 3)}) {
    setState(() {
      _display = true;
      _displayContent = content;
    });
  }

  Widget notificationPlaceHolder() {
    return _display
        ? HighlightedContainer(
            highlightedColor: Colors.green.withAlpha(100),
            child: _displayContent,
          )
        : SizedBox();
  }
}
