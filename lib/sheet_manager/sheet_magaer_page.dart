import 'dart:io';

import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/define.dart';
import 'package:Tracker/file_manager_template/file_manager_page.dart';
import 'package:Tracker/file_manager_template/info_card/info_card.dart';
import 'package:Tracker/sheet_editor/sheet_editor.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SheetManagerPage extends StatefulWidget {
  const SheetManagerPage({Key key}) : super(key: key);

  @override
  _SheetManagerPageState createState() => _SheetManagerPageState();
}

class _SheetManagerPageState extends State<SheetManagerPage> {
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
      title: 'Sheet Manager',
      rootDir: ACTION_SHEET_DIR,
      actionhandler: infoCardPressedHandler,
      headingBuilder: (_) => Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child: Icon(Icons.description,
            color: Colors.lightGreen,
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
        exportAsTextMsg(file);
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

  void exportAsTextMsg(File f) {
    ActionSheet sheet = ActionSheetDecoder.getInstance().decode(f);
    Share.share(sheet.toShareMsg(), subject: 'Share an Action Sheet');
  }
}
