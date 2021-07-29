import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

mixin Guideline<T extends StatefulWidget> on State<T> {
  static final ValueKey<String> recordingButtonKey = ValueKey("record_btn");
  static final ValueKey<String> sheetManagerKey = ValueKey("sheet_mangaer");
  static final ValueKey<String> recordingManagerKey =
      ValueKey("recording_manager");
  static final ValueKey<String> topToolBarKey = ValueKey("top_tool_bar");
  static final List<Key> videoRecordingNodes = [
    recordingButtonKey,
    sheetManagerKey,
    recordingManagerKey,
    topToolBarKey
  ];

  Map<String, String> instruction;

  void loadInstructions(String assetPath) async {
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
