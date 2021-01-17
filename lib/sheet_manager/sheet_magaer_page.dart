import 'dart:io';

import 'package:Tracker/define.dart';
import 'package:Tracker/file_manager_template/file_manager_page.dart';
import 'package:Tracker/file_manager_template/info_card/info_card.dart';
import 'package:Tracker/sheet_editor/sheet_editor.dart';
import 'package:flutter/material.dart';

class SheetManager extends StatefulWidget {
  const SheetManager({Key key}) : super(key: key);

  @override
  _SheetManagerState createState() => _SheetManagerState();
}

class _SheetManagerState extends State<SheetManager> {
  GlobalKey<FileManagerPageState> _pageNode;

  @override
  void initState() {
    super.initState();

    _pageNode = GlobalKey<FileManagerPageState>();
  }

  @override
  Widget build(BuildContext context) {
    return FileManagerPage(
      key: _pageNode,
      title: 'Action Sheet',
      rootDir: ACTION_SHEET_DIR,
      actionhandler: infoCardPressedHandler,
      headingBuilder: (_) => Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child: Icon(Icons.description,
            size: Theme.of(context).textTheme.headline4.fontSize),
      ),
    );
  }

  void infoCardPressedHandler(INFO_CARD_ACTION cardAction, File file) {
    switch (cardAction) {
      case INFO_CARD_ACTION.CLONE:
        cloneAndOpenSheet(file);
        break;
      case INFO_CARD_ACTION.DELETE:
        deleteSheet(file);
        break;
      case INFO_CARD_ACTION.EDIT:
        openSheetEditor(file);
        break;
      case INFO_CARD_ACTION.EXPORT:
        break;
      case INFO_CARD_ACTION.SELECT:
        returnSelectedSheet(file);
        break;
    }
  }

  void cloneAndOpenSheet(File f) {
    _pageNode.currentState.openCreateFilePrompt().then((String alias) {
      if (alias != null) {
        f
            .copy(_pageNode.currentState.dirFullPath +
                alias +
                ACTION_SHEET_FILE_EXTENSION)
            .then((cloned) {
          cloned.setLastModified(DateTime.now());
          _pageNode.currentState.insertFileToDirectory(cloned);

          openSheetEditor(cloned);
        });
      }
    });
  }

  void deleteSheet(File f) {
    _pageNode.currentState.removeFile(f);
  }

  void openSheetEditor(File f) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SheetEditor(filePath: f.path);
    }));
  }

  void returnSelectedSheet(File f) {
    if (Navigator.canPop(context)) {
      Navigator.pop<File>(context, f);
    }
  }
}
