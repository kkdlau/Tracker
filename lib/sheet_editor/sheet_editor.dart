import 'dart:io';

import 'package:Tracker/action_sheet/action_description.dart';
import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/file_manager/info_card.dart';
import 'package:Tracker/sheet_editor/ActionCard.dart';
import 'package:flutter/material.dart';

class SheetEditor extends StatefulWidget {
  final String filePath;

  SheetEditor({Key key, @required this.filePath}) : super(key: key);

  @override
  _SheetEditorState createState() => _SheetEditorState();
}

class _SheetEditorState extends State<SheetEditor> {
  File f;
  ActionSheet _sheet;

  @override
  void initState() {
    super.initState();
    f = File(widget.filePath);
    _sheet = ActionSheetDecoder.getInstance().decode(f.readAsStringSync());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
      body: ReorderableListView(children: [
        ActionCard(
          heading: Text('1.', style: textTheme.subtitle2),
          description: ActionDescription('This is description.',
              Duration(milliseconds: 100000), Duration(milliseconds: 987)),
          key: Key('1'),
        ),
        ActionCard(
          heading: Text('2.', style: textTheme.subtitle2),
          description: ActionDescription('This is description.',
              Duration(milliseconds: 100000), Duration(milliseconds: 789)),
          key: Key('2'),
        ),
      ], onReorder: (int oldIdx, newIdx) {}),
    );
  }
}
