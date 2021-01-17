import 'package:Tracker/file_manager/file_manager_page.dart';
import 'package:Tracker/video_recording_page/recording_button.dart';
import 'package:Tracker/widgets/shadow_icon_button.dart';
import 'package:flutter/material.dart';

class BottomToolBar extends StatefulWidget {
  final bool isRecording;
  final void Function() onRecordingButtonPressed;
  final Orientation orientation;
  final void Function() onDocumentButtonPressed;
  final void Function() onMovieButtonPressed;
  const BottomToolBar(
      {Key key,
      @required this.isRecording,
      @required this.onRecordingButtonPressed,
      @required this.orientation,
      this.onDocumentButtonPressed,
      this.onMovieButtonPressed})
      : super(key: key);

  @override
  _BottomToolBarState createState() => _BottomToolBarState();
}

class _BottomToolBarState extends State<BottomToolBar> {
  void Function() onRecordingButtonPressed;

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  void initState() {
    super.initState();
    onRecordingButtonPressed = widget.onRecordingButtonPressed;
  }

  List<Widget> _toolbuttons() {
    return [
      UnconstrainedBox(
          child: ShadowIconButton(
        onPressed: widget.onDocumentButtonPressed,
        icon: Icons.description,
        size: Theme.of(context).textTheme.headline3.fontSize,
        color: Colors.white,
        shadows: [
          BoxShadow(blurRadius: 5.0, spreadRadius: 5.0, color: Colors.black)
        ],
      )),
      RecordingButton(
        isRecording: widget.isRecording,
        onPressed: onRecordingButtonPressed,
      ),
      UnconstrainedBox(
          child: ShadowIconButton(
        onPressed: widget.onMovieButtonPressed,
        icon: Icons.movie,
        size: Theme.of(context).textTheme.headline3.fontSize,
        color: Colors.white,
        shadows: [
          BoxShadow(blurRadius: 5.0, spreadRadius: 5.0, color: Colors.black)
        ],
      )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: widget.orientation == Orientation.landscape
            ? Alignment.centerRight
            : Alignment.bottomCenter,
        child: widget.orientation == Orientation.landscape
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _toolbuttons())
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _toolbuttons()));
  }
}
