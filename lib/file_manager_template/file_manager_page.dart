import 'dart:io';

import 'package:Tracker/define.dart';
import 'package:Tracker/file_manager_template/create_file_dialog.dart';
import 'package:Tracker/file_manager_template/info_card/info_card.dart';
import 'package:Tracker/file_manager_template/manger_config.dart';
import 'package:Tracker/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension on File {
  String get alias {
    if (this.path.contains('/'))
      return this.path.split('/').last.split('.').first;
    else
      return this.path.split('.').first;
  }
}

class FileManagerPage extends StatefulWidget {
  final String title;
  final String rootDir;
  final String fileType;
  final Widget Function(File) headingBuilder;
  final void Function(INFO_CARD_ACTION, File) actionhandler;
  final FileManagerConfiguration config;
  FileManagerPage(
      {Key key,
      @required this.title,
      @required this.rootDir,
      this.fileType = "file",
      this.headingBuilder,
      this.actionhandler,
      this.config = const FileManagerConfiguration()})
      : super(key: key);

  @override
  FileManagerPageState createState() => FileManagerPageState();
}

class FileManagerPageState extends State<FileManagerPage> {
  String dirFullPath;
  Future<void> _dirFuture;
  List<File> _availableFiles;
  GlobalKey<AnimatedListState> _fileListNode;

  @override
  void initState() {
    super.initState();

    _fileListNode = GlobalKey();

    _dirFuture = requestAvailableFiles(widget.rootDir);
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
    dirFullPath = d.path;

    List<FileSystemEntity> entity = await d.list().toList();

    _availableFiles = [];

    await Future.wait(entity.map((f) async {
      _availableFiles.add(File(f.path));
    }));

    _availableFiles
        .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return;
  }

  void removeFile(File f) {
    int index = _availableFiles.indexOf(f);

    _fileListNode.currentState.removeItem(index, (context, animation) {
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

  void insertFileToDirectory(File f) {
    _availableFiles.insert(0, f);
    _fileListNode.currentState
        .insertItem(0, duration: const Duration(milliseconds: 200));
  }

  Future<String> openCreateFilePrompt() async {
    return showCupertinoDialog<String>(
        context: context,
        builder: (context) {
          return CreateFileDialog(
            usedFileAlias: _fileAlias,
            fileType: widget.fileType,
          );
        });
  }

  Widget _fileCard(File f) {
    Widget headingWidget =
        widget.headingBuilder != null ? widget.headingBuilder(f) : null;
    return SafeArea(
      top: false,
      bottom: false,
      child: InfoCard(
        config: widget.config.cardConfig,
        heading: headingWidget,
        onActionSelected: (actionType) {
          widget.actionhandler(actionType, f);
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
          title: Text(widget.title),
          actions: widget.config.allowAddFile
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          openCreateFilePrompt().then((alias) {
                            File f = File(dirFullPath +
                                alias +
                                ACTION_SHEET_FILE_EXTENSION);
                            f.create().then((value) {
                              insertFileToDirectory(f);
                              Future.delayed(Duration(milliseconds: 300)).then(
                                  (value) => widget.actionhandler(
                                      INFO_CARD_ACTION.EDIT, f));
                            });
                          });
                        }),
                  )
                ]
              : [],
        ),
        body: FutureBuilder(
          future: _dirFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.done) {
              return AnimatedList(
                key: _fileListNode,
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
