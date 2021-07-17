import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

extension on NativeDeviceOrientation {
  toQuarterTurns() {
    switch (this) {
      case NativeDeviceOrientation.landscapeLeft:
        return -1;
      case NativeDeviceOrientation.landscapeRight:
        return 1;
      case NativeDeviceOrientation.portraitDown:
        return -2;
      default:
        return 0;
    }
  }
}

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

  double get screenHeight {
    return MediaQuery.of(context).size.height;
  }

  double get screenWidth {
    return MediaQuery.of(context).size.width;
  }

  double get cameraHeight {
    // just assume camera width = screen width
    return screenWidth / _controller.value.aspectRatio;
  }

  double get cameraWidth {
    return screenHeight / _controller.value.aspectRatio;
  }

  Future<int> quarterRotation() async {
    return (await NativeDeviceOrientationCommunicator()
            .orientation(useSensor: false))
        .toQuarterTurns();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: FutureBuilder<int>(
        future: quarterRotation(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return RotatedBox(
              quarterTurns: snapshot.data,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Transform.scale(
                    scale: (MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? screenWidth / cameraWidth
                            : screenHeight / cameraHeight) +
                        0.1,
                    child: CameraPreview(_controller)),
              ),
            );
          else {
            return Container();
          }
        },
      ),
    );
  }
}
