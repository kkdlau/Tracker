import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CONFIRM_STATE { SAVE_AND_QUIT, QUIT, CANCEL }

class ConfirmQuitDialog extends StatelessWidget {
  const ConfirmQuitDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Are you going to leave?"),
      content: Text("The changes won't be saved."),
      actions: [
        CupertinoButton(
            child: Text('Save And Quit'),
            onPressed: () {
              Navigator.pop(context, CONFIRM_STATE.SAVE_AND_QUIT);
            }),
        CupertinoTheme(
            data: CupertinoThemeData(primaryColor: Colors.red),
            child: CupertinoButton(
                child: Text('Quit'),
                onPressed: () {
                  Navigator.pop(context, CONFIRM_STATE.QUIT);
                })),
        CupertinoButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, CONFIRM_STATE.CANCEL);
            }),
      ],
    );
  }
}
