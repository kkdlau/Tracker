import 'package:Tracker/setting/boolean_setting.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode mode;

  ThemeNotifier() {
    useLightTheme(BooleanSetting.USE_LIGHT_THEME.savedValue, notify: false);
  }

  void useLightTheme(bool lightTheme, {bool notify = true}) {
    mode = lightTheme ? ThemeMode.light : ThemeMode.dark;

    notifyListeners();
  }
}
