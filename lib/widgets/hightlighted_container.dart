import 'package:flutter/material.dart';

class HighlightedContainer extends StatelessWidget {
  final Widget child;
  const HighlightedContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark.withAlpha(180),
          borderRadius: BorderRadius.circular(7.0)),
      child: child,
    );
  }
}
