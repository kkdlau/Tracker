import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class SubtitleBurner {
  static SubtitleBurner _instance;
  static SubtitleBurner get instance {
    return _instance == null ? _instance = SubtitleBurner._() : _instance;
  }

  static const String BURNING_CMD = '';

  final FlutterFFmpeg _ffmpeg = FlutterFFmpeg();

  SubtitleBurner._();

  Future<File> burnSubtitle(
      {String videoPath,
      String outputPath,
      String subtitlePath,
      String forceStyleArgs = ''}) async {
    if (forceStyleArgs.isNotEmpty) {
      forceStyleArgs = ':' + forceStyleArgs;
    }

    String cmd =
        "-y -i $videoPath -vf subtitles=$subtitlePath -c:v mpeg4 $outputPath";

    final int code = await _ffmpeg.execute(cmd);

    print('ffmpee execution code: $code');

    return File(outputPath);
  }
}
