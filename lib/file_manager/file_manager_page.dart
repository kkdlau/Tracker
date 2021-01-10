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

  @override
  void initState() {
    super.initState();

    _dirFuture = requestAvailableFiles(ACTION_SHEET_DIR);
  }

  Future<void> requestAvailableFiles(String dir) async {
    Directory d = await Utils.openFolder(dir);

    List<FileSystemEntity> entity = await d.list().toList();

    _availableFiles = [];

    await Future.wait(entity.map((f) async {
      print(f.path);
      print((await f.stat()).type);
      _availableFiles.add(File(f.path));
    }));

    return;
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
              return ListView.builder(
                  itemCount: _availableFiles.length,
                  itemBuilder: (context, idx) {
                    File f = _availableFiles[idx];
                    return InfoCard(
                      onActionSelected: (action) {
                        print(action);
                      },
                      fullPath: f.path,
                      date: f.lastModifiedSync(),
                    );
                  });
            } else {
              return Container();
            }
          },
        ));
  }
}
