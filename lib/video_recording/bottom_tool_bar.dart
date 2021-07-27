import 'package:Tracker/video_recording/recording_button.dart';
import 'package:Tracker/video_recording/stamp_button.dart';
import 'package:Tracker/widgets/shadow_icon_button.dart';
import 'package:flutter/material.dart';

/// [BottomToolBar] is a tool bar which consist of the following components:
/// - recording circle button: [onRecordingButtonPressed] is called if the button is pressed
/// - document icon button: [onDocumentButtonPressed] is called if the button is pressed
/// - movie icon button: [onMovieButtonPressed] is called if the button is pressed
///
/// Button alignment in different orientation:
/// - Portrait: left to right
/// - Landscape: top to down
class BottomToolBar extends StatefulWidget {
  final bool isRecording;
  final void Function() onRecordingButtonPressed;
  final Orientation orientation;
  final void Function() onDocumentButtonPressed;
  final void Function() onMovieButtonPressed;
  final void Function() onStampButtonPressed;
  const BottomToolBar(
      {Key key,
      @required this.isRecording,
      @required this.onRecordingButtonPressed,
      @required this.orientation,
      this.onDocumentButtonPressed,
      this.onMovieButtonPressed,
      this.onStampButtonPressed})
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

  /// Generate a list of tool bar buttons.
  List<Widget> _toolbuttons() {
    final double ICON_SIZE = Theme.of(context).textTheme.headline3.fontSize;

    return [
      // Document Button
      UnconstrainedBox(
          child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: scalingTransitionBuilder,
        child: !widget.isRecording
            ? ShadowIconButton(
                onPressed: widget.onDocumentButtonPressed,
                icon: Icons.description,
                size: ICON_SIZE,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                      blurRadius: 5.0, spreadRadius: 5.0, color: Colors.black)
                ],
              )
            : SizedBox(
                width: ICON_SIZE,
                height: ICON_SIZE), // show nothing if it's recording
      )),
      // Recording Button
      RecordingButton(
        isRecording: widget.isRecording,
        onPressed: onRecordingButtonPressed,
      ),
      // Movie Button / Stamp button
      UnconstrainedBox(
          child: AnimatedSwitcher(
              transitionBuilder: scalingTransitionBuilder,
              duration: const Duration(milliseconds: 200),
              child: !widget.isRecording
                  ? ShadowIconButton(
                      onPressed: widget.onMovieButtonPressed,
                      icon: Icons.movie,
                      size: ICON_SIZE,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                            color: Colors.black)
                      ],
                    )
                  : StampButton())),
    ];
  }

  Widget scalingTransitionBuilder(Widget widget, Animation<double> aniamtion) =>
      ScaleTransition(scale: aniamtion, child: widget);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Align(
        alignment: widget.orientation == Orientation.landscape
            ? Alignment.centerRight
            : Alignment.bottomCenter,
        child: widget.orientation == Orientation.landscape
            ? Column(
                // landscape

                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.from(_toolbuttons().reversed))
            : Padding(
                padding: EdgeInsets.only(bottom: screenSize.height * 0.05),
                child: Row(
                    // portrait
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _toolbuttons()),
              ));
  }
}
