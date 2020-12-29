import 'package:CameraPlus/widgets/hightlighted_container.dart';
import 'package:flutter/material.dart';
import 'action_description.dart';

class ActionText extends StatelessWidget {
  final Duration time;
  final Duration timeDiff;
  final String data;

  const ActionText(
      {Key key,
      @required this.time,
      @required this.timeDiff,
      @required this.data})
      : super(key: key);

  TextSpan timeDiffText() {
    final String sign = timeDiff.isNegative ? '-' : '+';
    final int seconds = timeDiff.inSeconds;
    return TextSpan(
        style: TextStyle(
            color: seconds == 0
                ? Colors.grey
                : seconds > 0
                    ? Colors.green
                    : Colors.red),
        text: '[$sign${seconds.abs()}\s]\n');
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
                text: ActionDescription.durationToString(time, omitMS: true),
                style: TextStyle(fontWeight: FontWeight.bold)),
            timeDiffText(),
            TextSpan(text: data)
          ]))),
    );
  }

  ActionText.fromAction(ActionDescription action)
      : time = action.targetTime,
        timeDiff = action.timeDiff,
        data = action.description;
}
