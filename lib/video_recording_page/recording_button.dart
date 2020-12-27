import 'package:flutter/material.dart';

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
    print('rebuild');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onPressed,
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
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 5.0)),
          child: InnerButton(isRecording: widget.isRecording, isHolding: false),
        ));
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
          width: isRecording ? 25.0 : 50.0,
          height: isRecording ? 25.0 : 50.0,
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
