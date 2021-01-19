import 'package:Tracker/action_sheet/action_description.dart';
import 'package:flutter/cupertino.dart';
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

enum ACIONCARD_ACION { INSERT_ABOVE, INSERT_BELOW, DELETE, SELECT }

class ActionCard extends StatelessWidget {
  final Widget heading;
  final ActionDescription act;
  final void Function(ActionDescription, ACIONCARD_ACION) onPressed;

  const ActionCard({Key key, this.heading, this.act, this.onPressed})
      : super(key: key);

  List<Widget> _menuButtons(BuildContext context) {
    return [
      CupertinoButton(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.keyboard_arrow_up), Text('Insert above')]),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);

            if (onPressed != null) onPressed(act, ACIONCARD_ACION.INSERT_ABOVE);
          }),
      CupertinoButton(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.keyboard_arrow_down),
            Text('Insert below')
          ]),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);

            if (onPressed != null) onPressed(act, ACIONCARD_ACION.INSERT_BELOW);
          }),
      CupertinoTheme(
        data: CupertinoThemeData(primaryColor: Colors.red),
        child: CupertinoButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.delete), Text('Delete')]),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);

              if (onPressed != null) onPressed(act, ACIONCARD_ACION.DELETE);
            }),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
        onTap: () => onPressed(act, ACIONCARD_ACION.SELECT),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 15.0),
                      child: heading),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
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
                  const Expanded(child: const SizedBox()),
                  IconButton(
                      icon: Icon(Icons.more_horiz),
                      iconSize: 30.0,
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (_) {
                              return CupertinoActionSheet(
                                title: Text('Select the following action'),
                                actions: _menuButtons(context),
                              );
                            });
                      }),
                  const SizedBox(width: 10.0)
                ],
              ),
            ),
            const Divider(
              thickness: 2.0,
              height: 2.0,
            )
          ],
        ));
  }
}
