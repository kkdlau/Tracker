import 'package:Tracker/file_manager_template/card_pop_up_action_button.dart';
import 'package:Tracker/file_manager_template/info_card/card_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum INFO_CARD_ACTION { CLONE, DELETE, SELECT, EDIT, EXPORT }

class InfoCard extends StatelessWidget {
  final String fullPath;
  final DateTime date;
  final void Function(INFO_CARD_ACTION) onActionSelected;
  final Widget heading;
  final CardConfiguration config;
  const InfoCard(
      {Key key,
      this.fullPath,
      this.date,
      this.onActionSelected,
      this.heading,
      this.config = const CardConfiguration()})
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
    return LimitedBox(
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

  List<Widget> _listAvailableButton(BuildContext context) {
    List<Widget> btnList = [];

    if (config.allowExport)
      btnList.add(CardPopupActionButton(
        onPressed: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
          if (onActionSelected != null)
            onActionSelected(INFO_CARD_ACTION.EXPORT);
        },
        children: [Icon(Icons.upgrade), Text('Export')],
      ));
    if (config.allowEditFile) {
      btnList.add(CardPopupActionButton(
        onPressed: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
          if (onActionSelected != null) onActionSelected(INFO_CARD_ACTION.EDIT);
        },
        children: [Icon(Icons.edit), Text('Edit')],
      ));
    }

    if (config.allowCloneFile) {
      btnList.add(CardPopupActionButton(
        onPressed: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
          if (onActionSelected != null)
            onActionSelected(INFO_CARD_ACTION.CLONE);
        },
        children: [Icon(Icons.copy), Text('Clone')],
      ));
    }

    if (config.allowDeleteFile) {
      btnList.add(CardPopupActionButton(
        onPressed: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
          if (onActionSelected != null)
            onActionSelected(INFO_CARD_ACTION.DELETE);
        },
        children: [
          Icon(
            Icons.delete,
            color: Colors.red,
          ),
          Text('Delete', style: TextStyle(color: Colors.red))
        ],
      ));
    }

    return btnList;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    final List<Widget> list = _listAvailableButton(context);
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
            heading != null
                ? heading
                : SizedBox(
                    width: 30.0,
                  ),
            Expanded(child: _fileIntroTextSpan(context)),
            SizedBox(
              width: 10.0,
            ),
            list.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: Text(
                                  'Select the following action for $fileAlias'),
                              actions: list,
                              cancelButton: CardPopupActionButton(
                                onPressed: () {
                                  if (Navigator.canPop(context))
                                    Navigator.pop(context);
                                },
                                children: [Text('Cancel')],
                              ),
                            );
                          });
                    })
                : SizedBox(),
            SizedBox(width: 10.0)
          ],
        ));
  }
}
