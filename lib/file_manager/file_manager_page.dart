import 'dart:io';

import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/file_manager/create_file_dialog.dart';
import 'package:Tracker/file_manager/info_card.dart';
import 'package:Tracker/sheet_editor/sheet_editor.dart';
import 'package:Tracker/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../define.dart';

extension on File {
  String get alias {
    if (this.path.contains('/'))
      return this.path.split('/').last.split('.').first;
    else
      return this.path.split('.').first;
  }
}

class FileManagerPage extends StatefulWidget {
  FileManagerPage({Key key}) : super(key: key);

  @override
  _FileManagerPageState createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  String _dirFullPath;
  Future<void> _dirFuture;
  List<File> _availableFiles;
  GlobalKey<AnimatedListState> _fileListKey;

  @override
  void initState() {
    super.initState();

    _fileListKey = GlobalKey();

    _dirFuture = requestAvailableFiles(ACTION_SHEET_DIR);
  }

  /// helper function for getting all file alias.
  List<String> get _fileAlias {
    return _availableFiles.map((e) => e.alias).toList();
  }

  /// Get all available files in the given directory.
  ///
  /// [dir] is the directory that want to browse.
  Future<void> requestAvailableFiles(String dir) async {
    Directory d = await Utils.openFolder(dir);
    _dirFullPath = d.path;

    List<FileSystemEntity> entity = await d.list().toList();

    _availableFiles = [];

    await Future.wait(entity.map((f) async {
      _availableFiles.add(File(f.path));
    }));

    _availableFiles
        .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return;
  }

  Future<String> openCreateFilePrompt() async {
    return showCupertinoDialog<String>(
        context: context,
        builder: (context) {
          return CreateFileDialog(
            usedFileAlias: _fileAlias,
          );
        });
  }

  void onDeleteButtonPressed(File f) {
    int index = _availableFiles.indexOf(f);

    _fileListKey.currentState.removeItem(index, (context, animation) {
      Widget transitionWidget = SizeTransition(
        child: _fileCard(f),
        sizeFactor: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
      );

      _availableFiles.removeAt(index);
      f.delete();

      return transitionWidget;
    }, duration: const Duration(milliseconds: 200));
  }

  void onCloneButtonPressed(File f) {
    openCreateFilePrompt().then((String alias) {
      if (alias != null) {
        f
            .copy(_dirFullPath + alias + ACTION_SHEET_FILE_EXTENSION)
            .then((cloned) {
          cloned.setLastModified(DateTime.now());
          _availableFiles.insert(0, cloned);
          _fileListKey.currentState
              .insertItem(0, duration: const Duration(milliseconds: 200));

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SheetEditor(filePath: cloned.path);
          }));
        });
      }
    });
  }

  void onSelectButtonPressed(File f) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SheetEditor(filePath: f.path);
    }));
  }

  Widget _fileCard(File f) {
    return SafeArea(
      top: false,
      bottom: false,
      child: InfoCard(
        onActionSelected: (action) {
          switch (action) {
            case INFO_CARD_ACTION.DELETE:
              onDeleteButtonPressed(f);
              break;
            case INFO_CARD_ACTION.CLONE:
              onCloneButtonPressed(f);
              break;
            case INFO_CARD_ACTION.SELECT:
              onSelectButtonPressed(f);
              break;
          }
        },
        fullPath: f.path,
        date: f.lastModifiedSync(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: Text('Action Sheet'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    openCreateFilePrompt().then((value) => print(value));
                  }),
            )
          ],
        ),
        body: FutureBuilder(
          future: _dirFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.done) {
              return AnimatedList(
                key: _fileListKey,
                initialItemCount: _availableFiles.length,
                itemBuilder: (context, idx, animation) {
                  return SizeTransition(
                      sizeFactor: Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(animation),
                      child: _fileCard(_availableFiles[idx]));
                },
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
