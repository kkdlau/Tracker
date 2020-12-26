import 'package:flutter/material.dart';

class TimeCountText extends StatelessWidget {
  @required
  final String data;
  const TimeCountText(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(data, style: theme.textTheme.headline5),
      decoration: BoxDecoration(
          color: theme.primaryColorDark.withAlpha(100),
          borderRadius: BorderRadius.circular(7.0)),
    );
  }

  static TimeCountText fromDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));

    return TimeCountText(
        "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds");
  }
}
