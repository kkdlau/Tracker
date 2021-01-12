import 'package:Tracker/widgets/shadow_icon_button.dart';
import 'package:flutter/material.dart';

class TopToolBar extends StatefulWidget {
  final void Function() onSwitchBtnPressed;
  final void Function() onFlashBtnPressed;
  final bool enableFlash;

  const TopToolBar(
      {Key key,
      this.onSwitchBtnPressed,
      this.onFlashBtnPressed,
      this.enableFlash})
      : super(key: key);

  @override
  _TopToolBarState createState() => _TopToolBarState();
}

class _TopToolBarState extends State<TopToolBar> {
  @override
  void initState() {
    super.initState();
  }

  Widget _themedIconButton(
      BuildContext context, IconData icon, void Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: ShadowIconButton(
        onPressed: onPressed,
        icon: icon,
        size: Theme.of(context).textTheme.headline4.fontSize,
        color: Colors.white,
        shadows: [BoxShadow(blurRadius: 5.0, spreadRadius: 2.0)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _themedIconButton(
            context,
            widget.enableFlash ? Icons.flash_on : Icons.flash_off,
            widget.onFlashBtnPressed),
        _themedIconButton(
            context, Icons.flip_camera_ios, widget.onSwitchBtnPressed)
      ],
    );
  }
}
