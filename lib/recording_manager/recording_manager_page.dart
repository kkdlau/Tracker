import 'dart:io';
import 'dart:typed_data';

import 'package:Tracker/action_video_player/action_video_player.dart';
import 'package:Tracker/file_manager/file_manager_page.dart';
import 'package:Tracker/file_manager/info_card/card_config.dart';
import 'package:Tracker/file_manager/info_card/info_card.dart';
import 'package:Tracker/utils.dart';
import 'package:Tracker/video_recording/video_recording_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _listNode = GlobalKey();
  }

  Widget videoCardBuilder(File f) {
    return InfoCard(
      config:
          const CardConfiguration(allowCloneFile: false, allowEditFile: false),
      heading: videoThumbnail(f),
      onActionSelected: (actionType) {
        videoCardHandler(actionType, f);
      },
      fullPath: f.path,
      date: f.lastModifiedSync(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FileManagerPage(
      key: _listNode,
      title: 'Recordings',
      rootDir: RECORDING_DIR,
      fileItemBuilder: videoCardBuilder,
    );
  }

  Widget videoThumbnail(f) {
    Future<Uint8List> future = VideoThumbnail.thumbnailData(video: f.path);
    return FutureBuilder<Uint8List>(
      builder: (context, snapshot) {
        // it's possible that cannot get thumbnail because the video format is not supported by the plugin,
        // and the future returns null.
        // Therefore, to prevent rendering blank images, you need to check if snapshot.hasData == true
        bool hasReceivedData =
            snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData;
        return Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: hasReceivedData
                ? Image.memory(
                    snapshot.data,
                    height: 30.0,
                  )
                : Icon(Icons.perm_media));
      },
      future: future,
    );
  }

  Future<String> getSheetPath(String videoAlias) async {
    return Utils.fullPathToSheet(videoAlias);
  }

  void videoCardHandler(INFO_CARD_ACTION actionType, File file) {
    switch (actionType) {
      case INFO_CARD_ACTION.EXPORT:
        Share.shareFiles([file.path]);
        break;
      case INFO_CARD_ACTION.DELETE:
        // TODO: delete video with sheet record
        removeVideoFile(file);
        break;
      case INFO_CARD_ACTION.SELECT:
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return FutureBuilder<String>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ActionVideoPlayer(
                    videoPath: file.path,
                    sheetPath: snapshot.data, // path to sheet
                  );
                } else
                  return Container();
              },
              future: getSheetPath(file.alias));
        }));
        break;
      default:
    }
  }

  void removeVideoFile(File f) {
    _listNode.currentState.removeFile(f);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        VideoRecordingPage.perferedOrientations);
    super.dispose();
  }
}
