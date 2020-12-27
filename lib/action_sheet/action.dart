class Action {
  String _description;
  Duration _targetTime;

  Action(String description, Duration targetTime) {
    _description = description;
    _targetTime = targetTime;
  }

  /// Returns time difference between current time and target time.
  ///
  /// [time] is current time, [oeprator-] will calcuate the time difference by [target time - current time].
  Duration operator -(Duration time) {
    return _targetTime - time;
  }

  /// Returns string representation of current [Action] object.
  String toString() {
    return _description + ' - ' + _targetTime.toString();
  }

  /// Returns [Map] respresentation of current [Action] object.
  Map<String, String> toMap() {
    return {
      'description': _description,
      'time': _targetTime.toString(),
    };
  }

  /// Convert duration into string representation.
  /// Hours, minutes and seconds are fixed to two zero-padded digits.
  /// Milliseconds are fixed to three zero-padded digits.
  String durationToString(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    String twoDigitMS = (d.inMilliseconds % 1000).toString().padLeft(3, "0");

    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds,$twoDigitMS";
  }

  /// Convert [Action] into rst caption.
  /// It takes an [index], which is for indicating the display order.
  /// If [0] is input, display order will be omitted.
  ///
  /// [displayTime] controls how long to cpation will be displayed, it is 2 seconds by default.
  ///
  /// Details of the conversion:
  /// https://en.wikipedia.org/wiki/SubRip#File_format
  String toSRTFormat(
      {int index = 0, Duration displayTime = const Duration(seconds: 2)}) {
    String startTime = durationToString(_targetTime);
    String endTime = durationToString(_targetTime + displayTime);

    String indexHeader = index != 0 ? '' : '$index\n';
    String aliveTime = '$startTime --> $endTime\n';
    String captionBody = '[${durationToString(_targetTime)}] $_description\n';

    return '$indexHeader$aliveTime$captionBody';
  }

  /// Set the description of action.
  set description(String actionDescription) {
    _description = actionDescription;
  }

  /// Set the target time of action.
  set targetTime(Duration time) {
    _targetTime = time;
  }
}
