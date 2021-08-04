import 'dart:io';

import 'package:Tracker/utils.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'action_description.dart';
import 'dart:convert';

class ActionSheet {
  // the name of this sheet.
  String sheetName;

  // action list.
  List<ActionDescription> actions;

  bool linked;

  ActionSheet({this.actions, this.sheetName = "", this.linked = false}) {
    if (actions == null) actions = [];
  }

  /// Removes the sheet from file system.
  static removeFromDisk(String alias) async {
    String path = await Utils.fullPathToSheet(alias);
    var file = File(path);
    if (file.existsSync()) {
      file.delete();
      Utils.prefs.remove(alias);
    }
  }

  /// Returns [ActionDescription] list in Plain Map foramt.
  List<Map<String, String>> getPlainActionList() {
    List<Map<String, String>> actionList = [];
    actions.forEach((element) {
      actionList.add(element.toMap());
    });

    return actionList;
  }

  /// Convert the whole sheet (including action) to [Map].
  Map<String, dynamic> toMap() {
    return {
      'sheetName': sheetName,
      'actions': getPlainActionList(),
      "linked": this.linked
    };
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

  ActionSheet clone() {
    List<ActionDescription> clone = [];
    actions.forEach((element) {
      clone.add(element);
    });

    return ActionSheet(sheetName: sheetName, actions: clone);
  }

  /// save the sheet into given path.
  ///
  /// If the sheet is linked to another video file (i.e. [linked] is true),
  /// then inside SharedPreferences the path will be used as a key to mark this sheet as linked.
  Future<File> saveTo(String path) async {
    File f = File(path);

    if (this.linked) {
      Utils.prefs.setBool(f.alias, true);
    }

    return f.writeAsString(json.encode(this.toMap()));
  }

  /// Convert the whole action sheet into subtitle format.
  ///
  /// Due to the restriction of Chewie subtitle format (it only can pass String to Subtitle),
  /// the subtitles will be converted into JSON format.
  ///
  /// In the subtitle builder, you will receive the action description in String with JSON format.
  /// If you pass the string without converting it, you will everntually print some weird on the screen.
  /// So don't forget to convert the string back to [ActionDescription].
  Subtitles toSubtitles() {
    if (actions.length == 0)
      return Subtitles([]);
    else
      return Subtitles(List.generate(actions.length, (i) {
        ActionDescription act = actions[i];
        Duration happenedTime = act.targetTime + act.timeDiff;
        Duration endTime = happenedTime +
            Duration(
                milliseconds:
                    Utils.calculateCaptionDisplayTime(act.description.length));

        return Subtitle(
            index: i,
            start: happenedTime,
            end: endTime,
            text: json.encode(act.toMap()));
      }));
  }
}
