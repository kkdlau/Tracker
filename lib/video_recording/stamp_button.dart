import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StampButton extends StatefulWidget {
  static const double SIZE = 40;
  static const double HOLDING_SIZE = 30;

  final void Function() onPressed;
  final int count;

  StampButton({Key key, this.onPressed, this.count}) : super(key: key);

  @override
  _StampButtonState createState() => _StampButtonState();
}

class _StampButtonState extends State<StampButton> {
  bool holding;

  @override
  void initState() {
    super.initState();
    holding = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: StampButton.SIZE,
      height: StampButton.SIZE,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            HapticFeedback.selectionClick();
            holding = true;
          });
        },
        onTap: tapHandler,
        onTapCancel: tapHandler,
        child: Center(
          child: AnimatedContainer(
            child: Center(
              child: Text(
                widget.count.toString(),
                style: TextStyle(
                    fontSize: StampButton.HOLDING_SIZE * 0.6,
                    color: Colors.black),
              ),
            ),
            width: holding ? StampButton.HOLDING_SIZE : StampButton.SIZE,
            height: holding ? StampButton.HOLDING_SIZE : StampButton.SIZE,
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 2.0)],
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  void tapHandler() {
    setState(() {
      holding = false;
      if (widget.onPressed != null) widget.onPressed();
    });
  }
}
