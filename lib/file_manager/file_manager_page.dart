import 'dart:io';

import 'package:CameraPlus/file_manager/create_file_dialog.dart';
import 'package:CameraPlus/file_manager/info_card.dart';
import 'package:CameraPlus/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ACTION_SHEET_DIR = "action_sheets/";

class FileManagerPage extends StatefulWidget {
  FileManagerPage({Key key}) : super(key: key);

  @override
  _FileManagerPageState createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  Directory dir;
  Future<void> _dirFuture;
  List<File> _availableFiles;
  GlobalKey<AnimatedListState> _fileListState;

  @override
  void initState() {
    super.initState();

    _fileListState = GlobalKey();

    _dirFuture = requestAvailableFiles(ACTION_SHEET_DIR);
  }

  Future<void> requestAvailableFiles(String dir) async {
    Directory d = await Utils.openFolder(dir);

    List<FileSystemEntity> entity = await d.list().toList();

    _availableFiles = [];

    // await File(d.path + 'Robocon 2023.json').createSync();

    await Future.wait(entity.map((f) async {
      print(f.path);
      print((await f.stat()).type);
      _availableFiles.add(File(f.path));
    }));

    _availableFiles
        .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return;
  }

  Widget _fileCard(File f) {
    return InfoCard(
      onActionSelected: (action) {
        if (action == INFO_CARD_ACTION.DELETE) {
          int index = _availableFiles.indexOf(f);

          _fileListState.currentState.removeItem(index, (context, animation) {
            Widget transitionWidget = SizeTransition(
              child: _fileCard(f),
              sizeFactor: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
            );

            _availableFiles.remove(f);
            f.delete();

            return transitionWidget;
          }, duration: const Duration(milliseconds: 200));
        }
      },
      fullPath: f.path,
      date: f.lastModifiedSync(),
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
                    showCupertinoDialog<String>(
                        context: context,
                        builder: (context) {
                          return CreateFileDialog(
                            usedFileAlias: [],
                          );
                        }).then((value) {
                      print(value);
                    });
                  }),
            )
          ],
        ),
        body: FutureBuilder(
          future: _dirFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.done) {
              return AnimatedList(
                key: _fileListState,
                initialItemCount: _availableFiles.length,
                itemBuilder: (context, idx, animation) {
                  return _fileCard(_availableFiles[idx]);
                },
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
