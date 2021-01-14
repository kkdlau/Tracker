import 'package:Tracker/action_sheet/action_description.dart';
import 'package:flutter/material.dart';

extension on Duration {
  String toTimestampRepresentation() {
    final String min = this.inMinutes.toString().padLeft(2, '0');
    final String sec = (this.inSeconds % 60).toString().padLeft(2, '0');
    final String mil =
        ((this.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$min:$sec,$mil';
  }
}

class ActionCard extends StatelessWidget {
  final Widget heading;
  final ActionDescription description;

  const ActionCard({Key key, this.heading, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RawMaterialButton(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                child: heading),
            RichText(
                text: TextSpan(
                    style: textTheme.subtitle2, children: <TextSpan>[])),
            Text(description.targetTime.toTimestampRepresentation()),
            Expanded(child: SizedBox()),
            IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
            SizedBox(width: 10.0)
          ],
        ));
  }
}
