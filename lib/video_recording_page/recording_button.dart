import 'package:flutter/material.dart';

class RecordingButton extends AnimatedWidget {
  final Widget child;
  final shapeTween;
  final bool isRecording;
  final void Function() onPressed;
  const RecordingButton(
      {Key key,
      this.child,
      Animation<double> animation,
      this.shapeTween,
      this.isRecording,
      this.onPressed})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 5.0)),
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      ),
    );
  }
}
