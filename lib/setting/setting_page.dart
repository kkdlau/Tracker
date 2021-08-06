import 'package:Tracker/setting/boolean_setting.dart';
import 'package:Tracker/setting/option_setting.dart';
import 'package:Tracker/theme_notifier.dart';
import 'package:Tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Map<BooleanSetting, bool> tmpSetting = {};

  @override
  void initState() {
    super.initState();

    BooleanSetting.values.forEach((setting) => initializeWithPrefs(setting));
  }

  void initializeWithPrefs(BooleanSetting setting) {
    tmpSetting[setting] = Utils.prefs.containsKey(setting.savingPath)
        ? Utils.prefs.getBool(setting.savingPath)
        : setting.defaultValue;
  }

  void updateBooleanSetting(BooleanSetting setting, bool value) {
    Utils.prefs.setBool(setting.savingPath, value);
    setState(() {
      tmpSetting[setting] = value;
    });
  }

  SettingsTile booleanSeetingTile(BooleanSetting setting,
          {void Function(bool) onToggle}) =>
      SettingsTile.switchTile(
        title: setting.description,
        onToggle: (bool value) {
          updateBooleanSetting(setting, value);
          if (onToggle != null) onToggle(value);
        },
        switchValue: tmpSetting[setting],
      );

  void informThemeChanges(bool lightTheme) {
    Provider.of<ThemeNotifier>(context, listen: false)
        .useLightTheme(lightTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Setting'),
        ),
        body: SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
              title: 'General:',
              tiles: [
                booleanSeetingTile(BooleanSetting.USE_LIGHT_THEME,
                    onToggle: (v) {
                  informThemeChanges(v);
                })
              ],
            ),
            SettingsSection(
              title: 'When deleting video recordings:',
              tiles: [booleanSeetingTile(BooleanSetting.DELETE_SHEET)],
            ),
            SettingsSection(
              title: 'When deleting stamp sheets:',
              tiles: [booleanSeetingTile(BooleanSetting.DELETE_VIDEO)],
            ),
            SettingsSection(
              title: 'Test section',
              tiles: [OptionSettingTile(OptionSetting.CAMERA_QUALITY)],
            )
          ],
        ));
  }
}
