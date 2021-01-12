import 'package:Tracker/video_recording_page/recording_button.dart';
import 'package:Tracker/widgets/shadow_icon_button.dart';
import 'package:flutter/material.dart';

class BottomToolBar extends StatefulWidget {
  final bool isRecording;
  final void Function() onRecordingButtonPressed;
  const BottomToolBar(
      {Key key,
      @required this.isRecording,
      @required this.onRecordingButtonPressed})
      : super(key: key);

  @override
  _BottomToolBarState createState() => _BottomToolBarState();
}

class _BottomToolBarState extends State<BottomToolBar> {
  bool isRecording;
  void Function() onRecordingButtonPressed;

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  void initState() {
    super.initState();

    isRecording = widget.isRecording;
    onRecordingButtonPressed = widget.onRecordingButtonPressed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 200.0,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UnconstrainedBox(
                  child: ShadowIconButton(
                onPressed: () {},
                icon: Icons.description,
                size: Theme.of(context).textTheme.headline3.fontSize,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                      blurRadius: 5.0, spreadRadius: 5.0, color: Colors.black)
                ],
              )),
              RecordingButton(
                isRecording: isRecording,
                onPressed: onRecordingButtonPressed,
              ),
              UnconstrainedBox(
                child: Placeholder(
                  color: Colors.white,
                  fallbackWidth: 50.0,
                  fallbackHeight: 50.0,
                ),
              )
            ]));
  }
}
