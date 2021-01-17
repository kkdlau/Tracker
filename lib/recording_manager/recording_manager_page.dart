import 'dart:typed_data';

import 'package:Tracker/file_manager_template/file_manager_page.dart';
import 'package:Tracker/file_manager_template/info_card/card_config.dart';
import 'package:Tracker/file_manager_template/manger_config.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../define.dart';

class RecordingManagerPage extends StatefulWidget {
  RecordingManagerPage({Key key}) : super(key: key);

  @override
  _RecordingManagerPageState createState() => _RecordingManagerPageState();
}

class _RecordingManagerPageState extends State<RecordingManagerPage> {
  @override
  Widget build(BuildContext context) {
    return FileManagerPage(
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
    );
  }
}
