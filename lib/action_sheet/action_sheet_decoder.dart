import 'package:Tracker/action_sheet/action_description.dart';

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
      _sheet.actions.add(ActionDescription.fromJSON(element));
    });
  }

  ///  Decode file data into [ActionSheet].
  ///
  /// [rawFileData] is the raw string data from the file.
  ActionSheet decode(String rawFileData) {
    final Map<String, dynamic> mapped = json.decode(rawFileData);

    _sheet = ActionSheet();

    mapped.forEach((key, value) {
      if (key == "actions") {
        _decodeActions(value);
      }
    });

    return _sheet.clone();
  }
}
