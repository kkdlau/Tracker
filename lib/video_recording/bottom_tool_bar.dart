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
  final int stampCount;
  const BottomToolBar(
      {Key key,
      @required this.isRecording,
      @required this.onRecordingButtonPressed,
      @required this.orientation,
      this.onDocumentButtonPressed,
      this.onMovieButtonPressed,
      this.onStampButtonPressed,
      this.stampCount})
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
    final double iconSize = Theme.of(context).textTheme.headline3.fontSize;

    // if onStampButtonPressed is null, don't render stamp button and render a blank box instead.
    Widget stampPlaceHolder = widget.onStampButtonPressed != null
        ? StampButton(
            onPressed: widget.onStampButtonPressed,
            count: widget.stampCount,
          )
        : SizedBox(
            width: StampButton.SIZE,
            height: StampButton.SIZE,
          );

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
                size: iconSize,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                      blurRadius: 5.0, spreadRadius: 5.0, color: Colors.black)
                ],
              )
            : SizedBox(
                width: iconSize,
                height: iconSize), // show nothing if it's recording
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
                      size: iconSize,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                            color: Colors.black)
                      ],
                    )
                  : stampPlaceHolder)),
    ];
  }

  Widget scalingTransitionBuilder(Widget widget, Animation<double> animation) =>
      ScaleTransition(scale: animation, child: widget);

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
                padding: EdgeInsets.only(bottom: screenSize.height * 0.1),
                child: Row(
                    // portrait
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _toolbuttons()),
              ));
  }
}
