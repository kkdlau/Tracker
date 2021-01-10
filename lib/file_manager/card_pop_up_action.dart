import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardPopupAction extends StatelessWidget {
  final void Function() onPressed;
  final List<Widget> children;
  const CardPopupAction({Key key, @required this.children, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children),
    );
  }
}
