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
  final ActionDescription act;
  final void Function(ActionDescription) onPressed;

  const ActionCard({Key key, this.heading, this.act, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
        onTap: () => onPressed(act),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.all(15.0), child: heading),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act.description,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.subtitle1,
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              style: textTheme.caption.copyWith(height: 1.5),
                              text: 'Target time: ' +
                                  act.targetTime.toTimestampRepresentation() +
                                  's',
                              children: [
                                TextSpan(
                                    text: '   Time difference: ' +
                                        act.timeDiffString(),
                                    style:
                                        TextStyle(color: act.timeDiffColor()))
                              ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2.0,
              height: 2.0,
            )
          ],
        ));
  }
}
