import 'package:Tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

enum BooleanSetting { DELETE_SHEET, DELETE_VIDEO }

extension BooleanSettingExtension on BooleanSetting {
  /// Gets default value of the setting.
  ///
  /// The value should be used only if the setting haven't been saved in [SharedPreferences].
  bool get defaultValue {
    switch (this) {
      case BooleanSetting.DELETE_SHEET:
        return true;
      case BooleanSetting.DELETE_VIDEO:
        return false;
      default:
        throw Exception('Unhandled Case: BooleanSetting - ' +
            this.toString() +
            ' does not have deafult value.');
    }
  }

  /// Gets the description of the setting.
  String get description {
    switch (this) {
      case BooleanSetting.DELETE_SHEET:
        return "Also delete linked sheets";
      case BooleanSetting.DELETE_VIDEO:
        return "Also delete linked videos";
      default:
        throw Exception('Unhandled Case: BooleanSetting - ' +
            this.toString() +
            ' does not provide a description.');
    }
  }

  /// Get current configuration.
  ///
  /// If the configuration is not found in [SharedPreferences], default value will be returned.
  bool get savedValue {
    return Utils.prefs.containsKey(this.toString())
        ? Utils.prefs.getBool(this.toString())
        : this.defaultValue;
  }
}

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

    initializeWithPrefs(BooleanSetting.DELETE_SHEET);
    initializeWithPrefs(BooleanSetting.DELETE_VIDEO);
  }

  void initializeWithPrefs(BooleanSetting settingAttribute) {
    tmpSetting[settingAttribute] =
        Utils.prefs.containsKey(settingAttribute.toString())
            ? Utils.prefs.getBool(settingAttribute.toString())
            : settingAttribute.defaultValue;
  }

  void updateBooleanSetting(BooleanSetting settingAttribute, bool value) {
    Utils.prefs.setBool(settingAttribute.toString(), value);
    setState(() {
      tmpSetting[settingAttribute] = value;
    });
  }

  SettingsTile booleanSeetingTile(BooleanSetting settingAttribute) =>
      SettingsTile.switchTile(
        title: settingAttribute.description,
        onToggle: (bool value) {
          updateBooleanSetting(settingAttribute, value);
        },
        switchValue: tmpSetting[settingAttribute],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: Text('Setting'),
        ),
        body: SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
              title: 'When deleting video recordings:',
              tiles: [booleanSeetingTile(BooleanSetting.DELETE_SHEET)],
            ),
            SettingsSection(
              title: 'When deleting stamp sheets:',
              tiles: [booleanSeetingTile(BooleanSetting.DELETE_VIDEO)],
            )
          ],
        ));
  }
}
