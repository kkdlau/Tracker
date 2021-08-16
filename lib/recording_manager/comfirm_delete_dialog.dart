import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Delete File'),
      content: Text('The linked sheet will be also deleted'),
      actions: [
        CupertinoTheme(
            data: CupertinoThemeData(primaryColor: Colors.red),
            child: CupertinoButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false))),
        CupertinoButton(
            child: Text('OK'), onPressed: () => Navigator.of(context).pop(true))
      ],
    );
  }
}
