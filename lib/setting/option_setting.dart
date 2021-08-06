import 'package:Tracker/setting/option_select_page.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../utils.dart';

enum OptionSetting { CAMERA_QUALITY }

extension OptionSettingMethod on OptionSetting {
  String get savingPath {
    return this.toString();
  }

  String get savedValue {
    return Utils.prefs.containsKey(this.toString())
        ? Utils.prefs.getString(this.toString())
        : this.defaultValue;
  }

  List<String> get options {
    switch (this) {
      case OptionSetting.CAMERA_QUALITY:
        return ["Low", "Medium", "High", "Very high", "Ultra high"];
      default:
        throw Exception(
            "OptionSetting - ${this.toString()} does not have options.");
    }
  }

  String get defaultValue {
    switch (this) {
      case OptionSetting.CAMERA_QUALITY:
        return this.options.last;
      default:
        throw Exception(
            "OptionSetting - ${this.toString()} does not have default value.");
    }
  }

  String get description {
    switch (this) {
      case OptionSetting.CAMERA_QUALITY:
        return "Choosing different preview quality may affect application's performance. Low provides the fastest rendering speed, meanwhile Ultra High provides the best preview quality, but it may slow down the application.";
      default:
        throw Exception(
            "OptionSetting - ${this.toString()} does not have description.");
    }
  }

  String get name {
    switch (this) {
      case OptionSetting.CAMERA_QUALITY:
        return "Camera Quality";
      default:
        throw Exception(
            "OptionSetting - ${this.toString()} does not have a name.");
    }
  }
}

class OptionSettingTile extends SettingsTile {
  final void Function(String) onOptionSelected;

  OptionSettingTile(OptionSetting setting, {this.onOptionSelected})
      : super(
            title: setting.name,
            onPressed: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OptionSelectPage(
                      setting: setting, onOptionSelected: onOptionSelected)));
            });
}
