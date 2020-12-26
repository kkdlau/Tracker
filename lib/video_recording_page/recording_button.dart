import 'package:flutter/material.dart';

class RecordingButton extends StatelessWidget {
  final void Function() onPressed;
  final bool isRecording;
  const RecordingButton({Key key, this.onPressed, this.isRecording})
      : super(key: key);

  static const double BUTTON_SIZE = 70.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: BUTTON_SIZE,
          height: BUTTON_SIZE,
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 5.0)),
          child: InnerButton(isRecording: isRecording),
        ));
  }
}

class InnerButton extends StatelessWidget {
  const InnerButton({
    Key key,
    @required this.isRecording,
  }) : super(key: key);

  @required
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UnconstrainedBox(
        child: AnimatedContainer(
          width: isRecording ? 25.0 : 50.0,
          height: isRecording ? 25.0 : 50.0,
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isRecording ? 5.0 : 25.0),
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
