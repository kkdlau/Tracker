import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const _CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}

class RecordingButton extends StatefulWidget {
  final void Function() onPressed;
  final bool isRecording;
  const RecordingButton({Key key, this.onPressed, this.isRecording})
      : super(key: key);

  static const double BUTTON_SIZE = 70.0;

  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  bool isHolding;

  @override
  void initState() {
    super.initState();
    isHolding = false;
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            if (widget.onPressed != null) widget.onPressed();
          },
          onTapDown: (_) {
            setState(() {
              isHolding = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isHolding = false;
            });
          },
          child: Container(
            width: RecordingButton.BUTTON_SIZE,
            height: RecordingButton.BUTTON_SIZE,
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  _CustomBoxShadow(blurRadius: 3.0, blurStyle: BlurStyle.outer)
                ],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5.0)),
            child:
                InnerButton(isRecording: widget.isRecording, isHolding: false),
          )),
    );
  }
}

class InnerButton extends StatelessWidget {
  const InnerButton({
    Key key,
    @required this.isRecording,
    this.isHolding,
  }) : super(key: key);

  @required
  final bool isRecording;
  @required
  final bool isHolding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UnconstrainedBox(
        child: AnimatedContainer(
          width: isRecording ? 25.0 : 54.0,
          height: isRecording ? 25.0 : 54.0,
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isRecording ? 5.0 : 25.0),
            color: isHolding ? Colors.red.shade400 : Colors.red,
          ),
        ),
      ),
    );
  }
}
