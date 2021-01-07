import 'package:flutter/material.dart';

class ShadowIconButton extends StatefulWidget {
  final IconData icon;
  final List<Shadow> shadows;
  final Color color;
  final double size;
  final void Function() onPressed;

  const ShadowIconButton(
      {Key key, this.icon, this.shadows, this.color, this.size, this.onPressed})
      : super(key: key);

  @override
  _ShadowIconButtonState createState() => _ShadowIconButtonState();
}

class _ShadowIconButtonState extends State<ShadowIconButton> {
  bool focusing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusing = false;
  }

  Color darkenColor() {
    double v = HSVColor.fromColor(widget.color).value;
    return HSVColor.fromColor(widget.color)
        .withValue(v < 0.3 ? .0 : v - 0.3)
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onPressed != null) widget.onPressed();
        setState(() {
          focusing = false;
        });
      },
      onTapCancel: () {
        setState(() {
          focusing = false;
        });
      },
      onTapDown: (_) {
        setState(() {
          focusing = true;
        });
      },
      child: Text(
        String.fromCharCode(widget.icon.codePoint),
        style: TextStyle(
            decoration: TextDecoration.none,
            fontFamily: widget.icon.fontFamily,
            fontWeight: FontWeight.normal,
            fontSize: widget.size,
            color: focusing ? darkenColor() : widget.color,
            height: 1,
            inherit: false,
            shadows: widget.shadows),
      ),
    );
  }
}
