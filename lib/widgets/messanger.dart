import 'package:Tracker/widgets/hightlighted_container.dart';
import 'package:flutter/material.dart';

class Messenger extends StatefulWidget {
  Messenger({Key key}) : super(key: key);

  static MessengerState of(BuildContext context) {
    return context.findRootAncestorStateOfType<MessengerState>();
  }

  @override
  MessengerState createState() => MessengerState();
}

class MessengerState extends State<Messenger> {
  String _msg;
  Widget _widget;

  @override
  void initState() {
    super.initState();
    _msg = '';
    _widget = SizedBox.shrink();
  }

  void showMessage(String message) {
    setState(() {
      _msg = message;
      buildWidget();
    });
  }

  void hideMessage() {
    showMessage('');
  }

  void buildWidget() {
    if (_msg == '') {
      _widget = SizedBox.shrink();
    } else {
      _widget = Align(
          key: UniqueKey(),
          alignment: Alignment.topRight,
          child: HighlightedContainer(
            child: Text(_msg),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0),
          child: AnimatedSwitcher(
              transitionBuilder: (widget, animation) {
                return FadeTransition(opacity: animation, child: widget);
              },
              duration: const Duration(milliseconds: 300),
              child: _widget)),
    );
  }
}
