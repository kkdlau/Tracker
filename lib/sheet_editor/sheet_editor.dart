import 'dart:io';
import 'package:Tracker/action_sheet/action_description.dart';
import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/file_manager_template/info_card/info_card.dart';
import 'package:Tracker/sheet_editor/action_card.dart';
import 'package:Tracker/sheet_editor/action_edit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:path/path.dart';

extension SwappableList<T> on List<T> {
  void swap(int oldIndex, int newIndex) {
    T old_element = this[oldIndex];
    this[oldIndex] = this[newIndex];
    this[newIndex] = old_element;
  }
}

final ActionSheet sheet = ActionSheet(
  actions: <ActionDescription>[
    ActionDescription('Test message: Game start.', Duration(seconds: 0),
        Duration(seconds: 0)),
    ActionDescription(
        'Every action consists of description, target time and time differences',
        Duration(seconds: 3),
        Duration(seconds: -3)),
    ActionDescription(
        'Red / Green text indicate the time differences of previous recording',
        Duration(seconds: 7),
        Duration(seconds: 3)),
    ActionDescription(
        'The display time of a caption is automatically calculated.',
        Duration(seconds: 11),
        Duration(seconds: 1))
  ],
);

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

    _sheet = sheet;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    int index = 1;

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
      body: ImplicitlyAnimatedReorderableList<ActionDescription>(
        areItemsTheSame: (oldItem, newItem) {
          return oldItem.toString() == newItem.toString();
        },
        itemBuilder:
            (BuildContext context, Animation<double> animation, action, int i) {
          return Reorderable(
              key: Key(action.toString()),
              child: ActionCard(
                onPressed: (selectedAction) {
                  showCupertinoDialog(
                      context: context,
                      builder: (_) {
                        return ActionEditDialog(action: action);
                      });
                },
                heading:
                    Text('${(i + 1).toString()}.', style: textTheme.headline6),
                act: action,
              ));
        },
        items: _sheet.actions,
        onReorderFinished: (item, int from, int to, List<dynamic> newItems) {},
      ),
    );
  }
}

// ReorderableListView(
//           children: _sheet.actions
//               .map((action) => ActionCard(
//                     key: Key(action.toString()),
//                     heading: Text('${(index++).toString()}.',
//                         style: textTheme.headline6),
//                     act: action,
//                   ))
//               .toList(),
//           onReorder: (int oldIdx, newIdx) {})
