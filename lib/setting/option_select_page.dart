import 'package:Tracker/setting/option_setting.dart';
import 'package:Tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class OptionSelectPage extends StatefulWidget {
  final OptionSetting setting;
  final void Function(String) onOptionSelected;
  OptionSelectPage({Key key, @required this.setting, this.onOptionSelected})
      : super(key: key);

  @override
  _OptionSelectPageState createState() => _OptionSelectPageState();
}

class _OptionSelectPageState extends State<OptionSelectPage> {
  List<SettingsTile> optionTiles() {
    String selected = widget.setting.savedValue;

    List<String> options = widget.setting.options;

    return List.generate(options.length, (index) {
      if (options[index] == selected) {
        return SettingsTile(
          title: options[index],
          onPressed: (_) => tilePressedHandler(options[index]),
          trailing: Icon(Icons.done),
        );
      } else {
        return SettingsTile(
          title: options[index],
          onPressed: (_) => tilePressedHandler(options[index]),
          trailing: SizedBox(),
        );
      }
    });
  }

  void tilePressedHandler(String value) {
    Utils.prefs.setString(widget.setting.savingPath, value);
    if (widget.onOptionSelected != null) widget.onOptionSelected(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.setting.name),
      ),
      body: SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
              tiles: optionTiles(),
              subtitlePadding: const EdgeInsets.all(0),
              titlePadding: const EdgeInsets.all(0),
            ),
            SettingsSection(
              subtitle: Text(widget.setting.description),
              tiles: [],
              subtitlePadding: const EdgeInsets.all(10.0),
              titlePadding: const EdgeInsets.only(left: 10.0, right: 10.0),
            )
          ]),
    );
  }
}
