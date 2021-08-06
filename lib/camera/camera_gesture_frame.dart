import 'dart:math';

import 'package:flutter/material.dart';

class CameraGestureFrame extends StatefulWidget {
  final void Function(double scale) onScaling;
  final void Function(Point p) onTap;
  CameraGestureFrame({Key key, this.onScaling, this.onTap}) : super(key: key);

  @override
  _CameraGestureFrameState createState() => _CameraGestureFrameState();
}

class _CameraGestureFrameState extends State<CameraGestureFrame> {
  double calculateScale(ScaleUpdateDetails details) {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        widget.onScaling ?? widget.onScaling(1.0);
      },
    );
  }
}
