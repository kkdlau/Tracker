import 'dart:io';
import 'dart:math';

import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/define.dart';
import 'package:Tracker/file_manager/file_manager_page.dart';
import 'package:Tracker/file_manager/info_card/card_config.dart';
import 'package:Tracker/file_manager/info_card/info_card.dart';
import 'package:Tracker/setting/boolean_setting.dart';
import 'package:Tracker/sheet_editor/sheet_editor.dart';
import 'package:Tracker/utils.dart';
import 'package:Tracker/video_recording/video_recording_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _pageNode = GlobalKey<FileManagerPageState>();
  }

  Widget _fileCard(File f) {
    return InfoCard(
      config: const CardConfiguration(),
      heading: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child: Utils.prefs.containsKey(f.alias)
            ? linkedDocumentIcon(Colors.lightBlue)
            : documentIcon(Colors.lightGreen),
      ),
      onActionSelected: (actionType) {
        infoCardPressedHandler(actionType, f);
      },
      fullPath: f.path,
      date: f.lastModifiedSync(),
    );
  }

  /// Returns a colored document icon with a link logo.
  Widget linkedDocumentIcon(Color color) {
    return Stack(
      children: [
        documentIcon(color),
        Transform.translate(
          offset: const Offset(15, -10),
          child: Transform.rotate(
            angle: pi / 4,
            child: Icon(Icons.link,
                color: Theme.of(context).textTheme.headline6.color,
                size: Theme.of(context).textTheme.headline5.fontSize),
          ),
        ),
      ],
    );
  }

  /// Returns a document icon with given [color].
  Widget documentIcon(Color color) => Icon(Icons.description,
      color: color, size: Theme.of(context).textTheme.headline4.fontSize);

  @override
  Widget build(BuildContext context) {
    return FileManagerPage(
      key: _pageNode,
      title: 'Sheet Manager',
      allowCreateFile: true,
      rootDir: ACTION_SHEET_DIR,
      fileItemBuilder: (File f) => _fileCard(f),
      createdFileCallback: openSheetEditor,
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

    if (BooleanSetting.DELETE_VIDEO.savedValue) {
      Utils.fullPathToVideo(f.alias).then((path) {
        File f = File(path);

        if (f.existsSync()) {
          f.delete();
        }
      });
    }
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
    Share.share(sheet.toShareMsg(), subject: 'Share a sheet');
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        VideoRecordingPage.perferedOrientations);
    super.dispose();
  }
}
