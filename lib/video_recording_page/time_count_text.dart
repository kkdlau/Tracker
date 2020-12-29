import 'package:CameraPlus/widgets/hightlighted_container.dart';
import 'package:flutter/material.dart';

class TimeCountText extends StatelessWidget {
  @required
  final String data;
  const TimeCountText(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return HighlightedContainer(
      child: Text(data, style: theme.textTheme.headline5),
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
