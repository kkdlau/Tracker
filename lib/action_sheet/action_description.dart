import 'package:Tracker/action_sheet/action_text.dart';
import 'package:flutter/material.dart';

class ActionDescription {
  String description;
  Duration targetTime;
  Duration timeDiff;

  static ActionDescription get EmptyTemplate {
    return ActionDescription('', const Duration(), const Duration());
  }

  ActionDescription(String description, Duration targetTime, Duration timeDiff)
      : description = description,
        targetTime = targetTime,
        timeDiff = timeDiff;

  factory ActionDescription.fromJSON(Map<String, dynamic> json) {
    return ActionDescription(
      json['description'],
      Duration(milliseconds: int.parse(json['expect'])),
      Duration(milliseconds: int.parse(json['diff'])),
    );
  }

  /// Returns time difference between current time and target time.
  ///
  /// [time] is current time, [oeprator-] will calcuate the time difference by [target time - current time].
  Duration operator -(Duration time) {
    return targetTime - time;
  }

  /// Returns string representation of current [ActionDescription] object.
  String toString() {
    return description +
        ' - Expect: ' +
        targetTime.toString() +
        ', Diff: ' +
        timeDiff.toString();
  }

  /// Returns [Map] respresentation of current [ActionDescription] object.
  Map<String, String> toMap() {
    return {
      'description': description,
      'expect': targetTime.inMilliseconds.toString(),
      'diff': timeDiff.inMilliseconds.toString()
    };
  }

  /// Convert duration into string representation.
  /// Hours, minutes and seconds are fixed to two zero-padded digits.
  /// Milliseconds are fixed to three zero-padded digits.
  static String durationToString(Duration d, {bool omitMS = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    String twoDigitMS =
        ',' + (d.inMilliseconds % 1000).toString().padLeft(3, "0");

    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds${omitMS ? '' : twoDigitMS}";
  }

  /// Convert [ActionDescription] into rst caption.
  /// It takes an [index], which is for indicating the display order.
  /// If [0] is input, display order will be omitted.
  ///
  /// [displayTime] controls how long to cpation will be displayed, it is 2 seconds by default.
  ///
  /// Details of the conversion:
  /// https://en.wikipedia.org/wiki/SubRip#File_format
  String toSRTFormat(
      {int index = 0, Duration displayTime = const Duration(seconds: 2)}) {
    String startTime = durationToString(targetTime);
    String endTime = durationToString(targetTime + displayTime);

    String indexHeader = index != 0 ? '' : '$index\n';
    String aliveTime = '$startTime --> $endTime\n';
    String captionBody = '[${durationToString(targetTime)}] $description\n';

    return '$indexHeader$aliveTime$captionBody';
  }

  ActionText buildCaptionWidget() {
    return ActionText.fromAction(this);
  }

  String timeDiffString() {
    if (timeDiff.inMilliseconds > 0) {
      return '+${timeDiff.inMilliseconds} ms';
    } else if (timeDiff.inSeconds < 0) {
      return '${timeDiff.inMilliseconds} ms';
    }
    return '0 ms';
  }

  Color timeDiffColor() {
    if (timeDiff.inSeconds > 0) {
      return Colors.green;
    } else if (timeDiff.inSeconds < 0) {
      return Colors.red;
    }
    return Colors.grey;
  }
}
