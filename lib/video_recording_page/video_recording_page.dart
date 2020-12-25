import 'package:CameraPlus/action_sheet/action_sheet.dart';
import 'package:flutter/material.dart';

class VideoRecordingPage extends StatefulWidget {
  // Path to action sheet.
  final String actionSheetPath;
  VideoRecordingPage({Key key, this.actionSheetPath}) : super(key: key);

  @override
  _VideoRecordingPageState createState() => _VideoRecordingPageState();
}

class _VideoRecordingPageState extends State<VideoRecordingPage> {
  ActionSheet sheet;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
