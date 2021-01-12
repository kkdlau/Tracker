import 'package:flutter/material.dart';

class EditableAction extends StatelessWidget {
  const EditableAction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 12.0, right: 20.0),
              child: Icon(Icons.reorder)),
          Flexible(child: TextField())
        ],
      ),
    );
  }
}
