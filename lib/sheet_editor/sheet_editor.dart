import 'dart:io';

import 'package:CameraPlus/file_manager/info_card.dart';
import 'package:flutter/material.dart';

class SheetEditor extends StatefulWidget {
  final String filePath;

  SheetEditor({Key key, @required this.filePath}) : super(key: key);

  @override
  _SheetEditorState createState() => _SheetEditorState();
}

class _SheetEditorState extends State<SheetEditor> {
  File f;

  @override
  void initState() {
    super.initState();
    f = File(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text(f.path.split('/').last.split('.').first),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(icon: Icon(Icons.save_alt), onPressed: () {}),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body:
          ReorderableListView(children: [], onReorder: (int oldIdx, newIdx) {}),
    );
  }
}
