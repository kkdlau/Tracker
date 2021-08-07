import 'package:Tracker/camera/focus_point.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension on DeviceOrientation {
  Orientation get inFlutterOrientation {
    switch (this) {
      case DeviceOrientation.portraitUp:
      case DeviceOrientation.portraitDown:
        return Orientation.portrait;
      default:
        return Orientation.landscape;
    }
  }
}

/// Full screen camera view with orientation support.
///
/// A wrapper widget for handling camera orientation, and resizing.
/// The widget doesn't has the responsibility to maintain the life cycle of camera controller.
class CameraViewer extends StatefulWidget {
  final CameraController controller;
  final void Function(ScaleUpdateDetails) scaleCallback;
  CameraViewer(this.controller, {Key key, this.scaleCallback})
      : super(key: key);

  @override
  CameraViewerState createState() => CameraViewerState();

  static CameraViewerState of(BuildContext context) {
    return context.findAncestorStateOfType<CameraViewerState>();
  }
}

class CameraViewerState extends State<CameraViewer> {
  CameraController _controller;
  Widget focus;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  void showFocusPoint(Offset pos) {
    setState(() {
      focus = FocusPoint(
          key: UniqueKey(),
          position: pos,
          onAnimationCompleted: removeFocusPoint);
    });
  }

  void setFocus(Offset pos) {
    _controller
        .setFocusPoint(Offset(pos.dx / cameraWidth, pos.dy / cameraHeight));
  }

  void removeFocusPoint() {
    setState(() {
      focus = null;
    });
  }

  /// Returns the height of camera preview.
  ///
  /// In different orientation, the height will be swapped with [width],
  /// hence you should always use this getter to handle orientation changes.
  double get cameraHeight {
    return _controller.value.deviceOrientation.inFlutterOrientation ==
            Orientation.portrait
        ? _controller.value.previewSize.width
        : _controller.value.previewSize.height;
  }

  /// Returns the width of camera preview.
  ///
  /// In different orientation, the width will be swapped with [height],
  /// hence you should always use this getter to handle orientation changes.
  double get cameraWidth {
    return _controller.value.deviceOrientation.inFlutterOrientation ==
            Orientation.portrait
        ? _controller.value.previewSize.height
        : _controller.value.previewSize.width;
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null)
      return Container(color: Theme.of(context).primaryColorDark);
    else {
      return Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: ValueListenableBuilder(
                  builder: (BuildContext context, value, Widget child) =>
                      GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      showFocusPoint(details.globalPosition);
                      setFocus(details.localPosition);
                    },
                    child: SizedBox(
                        width: cameraWidth,
                        height: cameraHeight,
                        child: CameraPreview(_controller)),
                  ),
                  valueListenable: _controller,
                )),
          ),
          focus
        ].where((e) => e != null).toList(),
      );
    }
  }
}
