import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String fullPath;
  final DateTime date;
  const InfoCard({Key key, this.fullPath, this.date}) : super(key: key);

  String _displayDate() {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();

    return "$day-$month-$year";
  }

  String get fileAlias {
    return fullPath.split('/').last.split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return Dismissible(
      direction: DismissDirection.endToStart, // swipe left to dismiss
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.delete),
          ),
        ),
      ),
      key: Key(fileAlias),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Icon(Icons.description, size: theme.headline5.fontSize),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.45),
              child: Text(
                fileAlias,
                style: theme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(child: SizedBox()),
            Text('Last modified: ${_displayDate()}'),
            SizedBox(width: 10.0)
          ],
        ),
      ),
    );
  }
}
