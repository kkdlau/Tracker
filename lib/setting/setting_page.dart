import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text('Setting'),
      ),
    );
  }
}
