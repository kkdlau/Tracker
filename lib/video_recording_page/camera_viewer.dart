import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewer extends StatefulWidget {
  final CameraController controller;
  CameraViewer({Key key, this.controller}) : super(key: key);

  @override
  _CameraViewerState createState() => _CameraViewerState();
}

class _CameraViewerState extends State<CameraViewer> {
  CameraController _controller;

  double _baseScaleFactor;
  double _scaleFactor;

  @override
  void initState() {
    _baseScaleFactor = _scaleFactor = 1.0;
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Center(
          child: GestureDetector(
        child: RotatedBox(
          quarterTurns:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 3
                  : 0,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
        ),
      ));
    });
  }
}
