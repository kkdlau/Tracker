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

  /// Set the description of action.
  set description(String actionDescription) {
    _description = actionDescription;
  }

  /// Set the target time of action.
  set targetTime(Duration time) {
    _targetTime = time;
  }
}
