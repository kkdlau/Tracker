import 'dart:io';
import 'dart:typed_data';

import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_video_player/action_video_player.dart';
import 'package:Tracker/file_manager/file_manager_page.dart';
import 'package:Tracker/file_manager/info_card/card_config.dart';
import 'package:Tracker/file_manager/info_card/info_card.dart';
import 'package:Tracker/setting/boolean_setting.dart';
import 'package:Tracker/setting/setting_page.dart';
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
  Map<File, Uint8List> _thumbnailCaches; // for saving thumbnail cache

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _listNode = GlobalKey();
    _thumbnailCaches = {};
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
    if (_thumbnailCaches.containsKey(f)) {
      return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Image.memory(
          _thumbnailCaches[f],
          height: 30.0,
        ),
      );
    }
    Future<Uint8List> future = VideoThumbnail.thumbnailData(
        video: f.path, imageFormat: ImageFormat.JPEG, maxHeight: 30);

    return FutureBuilder<Uint8List>(
      builder: (context, snapshot) {
        // it's possible that cannot get thumbnail because the video format is not supported by the plugin,
        // and the future returns null.
        // Therefore, to prevent rendering blank images, you need to check if snapshot.hasData == true
        bool hasReceivedData =
            snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData;
        if (hasReceivedData) {
          _thumbnailCaches[f] = snapshot.data; // save the cache
        }
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
        removeVideoAndLinkedSheet(file);
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

  void removeVideoAndLinkedSheet(File f) {
    _listNode.currentState.removeFile(f);
    _thumbnailCaches.remove(f); // remove useless image cache

    if (BooleanSetting.DELETE_SHEET.savedValue) {
      ActionSheet.removeFromDisk(f.alias); // also delete the linked file
    } else {
      ActionSheet.unlink(
          f.alias); // unlink the file if the file doesn't delete together
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        VideoRecordingPage.perferedOrientations);
    super.dispose();
  }
}
