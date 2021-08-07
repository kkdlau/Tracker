import 'package:flutter/material.dart';

class Ripple extends StatefulWidget {
  Ripple({Key key}) : super(key: key);

  @override
  _RippleState createState() => _RippleState();
}

class _RippleState extends State<Ripple> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    controller.addListener(() {
      setState(() {});
    });
    _playAnimation();
  }

  Future<void> _playAnimation() async {
    await controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: controller.value,
      child: Container(
        width: FocusPoint.MIN_DIAMETER,
        height: FocusPoint.MIN_DIAMETER,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(1 - controller.value),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class FocusPoint extends StatefulWidget {
  static const double MIN_DIAMETER = 50.0;
  static const double MAX_DIAMETER = 70.0;
  final Offset position;
  final void Function() onAnimationCompleted;

  FocusPoint({Key key, this.position, this.onAnimationCompleted})
      : super(key: key);

  @override
  _FocusPointState createState() => _FocusPointState();
}

class _FocusPointState extends State<FocusPoint> with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController opacityController;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        lowerBound: FocusPoint.MIN_DIAMETER,
        upperBound: FocusPoint.MAX_DIAMETER);

    opacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    controller.addListener(() {
      setState(() {});
    });

    opacityController.addListener(() {
      setState(() {});
    });

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    await controller.forward();
    await controller.reverse();
    await opacityController.forward();
    if (widget.onAnimationCompleted != null) {
      widget.onAnimationCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.position,
      child: Transform.translate(
        offset: Offset(-controller.value / 2, -controller.value / 2),
        child: Opacity(
          opacity: 1 - opacityController.value,
          child: Container(
            width: controller.value,
            height: controller.value,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(controller.value / 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: FocusPoint.MIN_DIAMETER,
                height: FocusPoint.MIN_DIAMETER,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Ripple(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    opacityController.dispose();
    super.dispose();
  }
}
