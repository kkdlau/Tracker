import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Full screen camera view with orientation support.
///
/// A wrapper widget for handling camera orientation, and resizing.
/// The widget doesn't has the responsibility to maintain the life cycle of camera controller.
class CameraViewer extends StatefulWidget {
  final CameraController controller;
  CameraViewer(this.controller, {Key key}) : super(key: key);

  @override
  _CameraViewerState createState() => _CameraViewerState();
}

class _CameraViewerState extends State<CameraViewer> {
  CameraController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
  }

  /// Returns the height of camera preview.
  ///
  /// In different orientation, the height will be swapped with [width],
  /// hence you should always use this getter to handle orientation changes.
  double get cameraHeight {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? _controller.value.previewSize.width
        : _controller.value.previewSize.height;
  }

  /// Returns the width of camera preview.
  ///
  /// In different orientation, the width will be swapped with [height],
  /// hence you should always use this getter to handle orientation changes.
  double get cameraWidth {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? _controller.value.previewSize.height
        : _controller.value.previewSize.width;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: FittedBox(
      clipBehavior: Clip.hardEdge,
      fit: BoxFit.cover,
      child: SizedBox(
          width: cameraWidth,
          height: cameraHeight,
          child: CameraPreview(_controller)),
    ));
  }
}
