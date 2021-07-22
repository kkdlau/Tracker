import 'dart:io';
import 'dart:typed_data';

import 'package:Tracker/action_video_player/action_video_player.dart';
import 'package:Tracker/file_manager_template/file_manager_page.dart';
import 'package:Tracker/file_manager_template/info_card/card_config.dart';
import 'package:Tracker/file_manager_template/info_card/info_card.dart';
import 'package:Tracker/file_manager_template/manger_config.dart';
import 'package:Tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../define.dart';

class RecordingManagerPage extends StatefulWidget {
  RecordingManagerPage({Key key}) : super(key: key);

  @override
  _RecordingManagerPageState createState() => _RecordingManagerPageState();
}

class _RecordingManagerPageState extends State<RecordingManagerPage> {
  GlobalKey<FileManagerPageState> _listNode;

  @override
  void initState() {
    super.initState();
    _listNode = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return FileManagerPage(
      key: _listNode,
      config: FileManagerConfiguration(
          allowAddFile: false,
          cardConfig:
              CardConfiguration(allowCloneFile: false, allowEditFile: false)),
      title: 'Recordings',
      rootDir: RECORDING_DIR,
      headingBuilder: (f) {
        Future<Uint8List> future = VideoThumbnail.thumbnailData(video: f.path);
        return FutureBuilder<Uint8List>(
          builder: (context, snapshot) => Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: snapshot.connectionState == ConnectionState.done
                  ? Image.memory(
                      snapshot.data,
                      height: 30.0,
                    )
                  : Icon(Icons.perm_media)),
          future: future,
        );
      },
      actionhandler: videoCardHandler,
    );
  }

  Future<String> _tempActionSheet() async {
    Directory d = await Utils.openFolder(ACTION_SHEET_DIR);
    print(d.path);

    return d.path + 'robocon 2021.json';
  }

  void videoCardHandler(INFO_CARD_ACTION actionType, File file) {
    switch (actionType) {
      case INFO_CARD_ACTION.EXPORT:
        Share.shareFiles([file.path]);
        break;
      case INFO_CARD_ACTION.DELETE:
        // todo: delete video with sheet record
        removeVideoFile(file);
        break;
      case INFO_CARD_ACTION.SELECT:
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return FutureBuilder<String>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ActionVideoPlayer(
                    videoPath: file.path,
                    sheetPath: snapshot.data,
                  );
                } else
                  return Container();
              },
              future: _tempActionSheet());
        }));
        break;
      default:
    }
  }

  void removeVideoFile(File f) {
    _listNode.currentState.removeFile(f);
  }
}
