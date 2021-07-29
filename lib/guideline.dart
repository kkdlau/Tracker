import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

mixin Guideline<T extends StatefulWidget> on State<T> {
  static GlobalObjectKey recordingButtonKey = GlobalObjectKey("record_btn");
  static final GlobalObjectKey sheetManagerKey =
      GlobalObjectKey("sheet_mangaer");
  static final GlobalObjectKey recordingManagerKey =
      GlobalObjectKey("recording_manager");
  static final GlobalObjectKey topToolBarKey = GlobalObjectKey("top_tool_bar");
  static final List<Key> videoRecordingNodes = [
    recordingButtonKey,
    sheetManagerKey,
    recordingManagerKey,
    topToolBarKey
  ];

  static Map<String, dynamic> instruction;

  static Future<void> loadInstructions(String assetPath) async {
    instruction =
        jsonDecode(await rootBundle.loadString(assetPath, cache: false));
  }

  /// start guideline mode.
  ///
  /// The guideline will follow the given [nodes] and go through sequentially.
  void enableGuideline(List<Key> nodes) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowCaseWidget.of(context).startShowCase(nodes);
    });
  }
}
