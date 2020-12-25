import 'action.dart';
import 'dart:convert';

class ActionSheet {
  // the name of this sheet.
  String sheetName;

  // action list.
  List<Action> actions;

  ActionSheet({this.actions = const [], this.sheetName = ""}) {
    // placeholder
  }

  /// Returns [Action] list in Plain Map foramt.
  List<Map<String, String>> getPlainActionList() {
    List<Map<String, String>> actionList;
    actions.forEach((element) {
      actionList.add(element.toMap());
    });

    return actionList;
  }

  /// Convert the whole sheet (including action) to [Map].
  Map<String, dynamic> toMap() {
    return {'sheetName': sheetName, 'actions': getPlainActionList()};
  }

  /// Export the whole sheet into plain text format.
  String export() {
    return json.encode(this.toMap());
  }

  /// Convert the whole sheet into string message, usually for sharing the sheet.
  ///
  /// Messgae format:
  /// export date & time
  ///
  /// This is description of Action 1. - 00:00:01
  /// This is description of Action 2. - 00:00:15
  String toShareMsg() {
    String msg = DateTime.now().toString() + '\n';
    actions.forEach((element) {
      msg += element.toString() + '\n';
    });

    return msg;
  }
}
