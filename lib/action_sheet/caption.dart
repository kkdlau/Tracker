import 'package:Tracker/widgets/hightlighted_container.dart';
import 'package:flutter/material.dart';
import 'action_description.dart';

class Caption extends StatelessWidget {
  final Duration time;
  final Duration timeDiff;
  final String data;
  final Color color;

  const Caption(
      {Key key,
      @required this.time,
      @required this.timeDiff,
      @required this.data,
      @required this.color})
      : super(key: key);

  TextSpan timeDiffText() {
    final String sign = timeDiff.isNegative ? '-' : '+';
    final int ms = timeDiff.inMilliseconds;
    return TextSpan(
        style: TextStyle(color: color), text: '[$sign${ms.abs()}\ms]\n');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: HighlightedContainer(
          child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
            TextSpan(
                text: ActionDescription.durationToString(time + timeDiff,
                    omitMS: true),
                style: TextStyle(fontWeight: FontWeight.bold)),
            timeDiffText(),
            TextSpan(text: data)
          ]))),
    );
  }

  Caption.fromAction(ActionDescription action)
      : time = action.targetTime,
        timeDiff = action.timeDiff,
        data = action.description,
        color = action.timeDiffColor;
}
