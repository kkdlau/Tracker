import 'package:CameraPlus/file_manager/card_pop_up_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum INFO_CARD_ACTION { CLONE, DELETE, SELECT }

class InfoCard extends StatelessWidget {
  final String fullPath;
  final DateTime date;
  final void Function(INFO_CARD_ACTION) onActionSelected;
  const InfoCard({Key key, this.fullPath, this.date, this.onActionSelected})
      : super(key: key);

  String _displayDate() {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();

    return "$day-$month-$year";
  }

  String get fileAlias {
    return fullPath.split('/').last.split('.')[0];
  }

  Widget _fileIntroTextSpan(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          fileAlias,
          style: theme.subtitle1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Last modified: ${_displayDate()}',
          style: theme.caption,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return RawMaterialButton(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        onPressed: () {
          if (onActionSelected != null)
            onActionSelected(INFO_CARD_ACTION.SELECT);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
              child: Icon(Icons.description, size: theme.headline4.fontSize),
            ),
            _fileIntroTextSpan(context),
            Expanded(child: SizedBox()),
            IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return CupertinoActionSheet(
                          title: Text(
                              'Select the following action for $fileAlias'),
                          actions: [
                            CardPopupAction(
                              onPressed: () {
                                if (Navigator.canPop(context))
                                  Navigator.pop(context);
                                if (onActionSelected != null)
                                  onActionSelected(INFO_CARD_ACTION.CLONE);
                              },
                              children: [Icon(Icons.copy), Text('Clone')],
                            ),
                            CardPopupAction(
                              onPressed: () {
                                if (Navigator.canPop(context))
                                  Navigator.pop(context);
                                if (onActionSelected != null)
                                  onActionSelected(INFO_CARD_ACTION.DELETE);
                              },
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                Text('Delete',
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ],
                          cancelButton: CardPopupAction(
                            onPressed: () {
                              if (Navigator.canPop(context))
                                Navigator.pop(context);
                            },
                            children: [Text('Cancel')],
                          ),
                        );
                      });
                }),
            SizedBox(width: 10.0)
          ],
        ));
  }
}
