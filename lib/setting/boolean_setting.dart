import 'package:Tracker/utils.dart';

enum BooleanSetting { DELETE_SHEET, DELETE_VIDEO, USE_LIGHT_THEME }

extension BooleanSettingMethod on BooleanSetting {
  /// Gets default value of the setting.
  ///
  /// The value should be used only if the setting haven't been saved in [SharedPreferences].
  bool get defaultValue {
    switch (this) {
      case BooleanSetting.DELETE_SHEET:
        return true;
      case BooleanSetting.DELETE_VIDEO:
        return false;
      case BooleanSetting.USE_LIGHT_THEME:
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
      case BooleanSetting.USE_LIGHT_THEME:
        return "Use light theme";
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

  String get savingPath {
    return this.toString();
  }
}
