import 'package:flutter/material.dart';

class HighlightedContainer extends StatelessWidget {
  final Widget child;
  final Color highlightedColor;
  const HighlightedContainer({Key key, this.child, this.highlightedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: highlightedColor != null
              ? highlightedColor
              : Theme.of(context).primaryColorDark.withAlpha(180),
          borderRadius: BorderRadius.circular(7.0)),
      child: child,
    );
  }
}
