import 'package:flutter/material.dart';

class Messenger extends StatefulWidget {
  Messenger({Key key}) : super(key: key);

  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: AnimatedOpacity(
            opacity: 1.0, duration: const Duration(seconds: 1)));
  }
}
