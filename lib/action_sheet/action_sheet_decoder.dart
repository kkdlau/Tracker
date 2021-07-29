import 'dart:io';

import 'package:Tracker/action_sheet/action_description.dart';
import 'package:Tracker/utils.dart';

import 'action_sheet.dart';
import 'dart:convert';

/// Actionm Sheet Decoder.
class ActionSheetDecoder {
  ActionSheet _sheet;

  static ActionSheetDecoder _instance;

  /// Private constructor of [ActionSheetDecoder].
  ///
  /// It should be called once only.
  ActionSheetDecoder._();

  /// Helper function for getting an instance of [ActionSheetDecoder].
  static ActionSheetDecoder getInstance() {
    if (_instance == null) {
      _instance = ActionSheetDecoder._();
    }

    return _instance;
  }

  void _decodeActions(List<dynamic> data) {
    data.forEach((element) {
      _sheet.actions.add(ActionDescription.fromMap(element));
    });
  }

  ///  Decode file data into [ActionSheet].
  ///
  /// If the given file is not exist, the file consist of empty content,
  /// an empty sheet is returned.
  ActionSheet decode(File f) {
    if (f == null || !f.existsSync()) return ActionSheet();
    String s = f.readAsStringSync();
    if (s.isEmpty) return ActionSheet(sheetName: f.alias);

    final Map<String, dynamic> mapped = json.decode(s);

    _sheet = ActionSheet();

    _sheet.sheetName = f.alias;

    mapped.forEach((key, value) {
      if (key == "actions") {
        _decodeActions(value);
      }
      if (key == "linked") {
        _sheet.linked = value as bool;
      }
    });

    return _sheet;
  }
}
