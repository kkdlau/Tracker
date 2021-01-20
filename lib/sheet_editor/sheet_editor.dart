import 'dart:convert';
import 'dart:io';
import 'package:Tracker/action_sheet/action_description.dart';
import 'package:Tracker/action_sheet/action_sheet.dart';
import 'package:Tracker/action_sheet/action_sheet_decoder.dart';
import 'package:Tracker/sheet_editor/action_card.dart';
import 'package:Tracker/sheet_editor/action_edit_dialog.dart';
import 'package:Tracker/sheet_editor/confirm_quit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

extension SwappableList<T> on List<T> {
  void swap(int oldIndex, int newIndex) {
    T oldElement = this[oldIndex];
    this[oldIndex] = this[newIndex];
    this[newIndex] = oldElement;
  }
}

class SheetEditor extends StatefulWidget {
  final String filePath;

  SheetEditor({Key key, @required this.filePath}) : super(key: key);

  @override
  _SheetEditorState createState() => _SheetEditorState();
}

class _SheetEditorState extends State<SheetEditor> {
  File f;
  ActionSheet _sheet;
  GlobalKey<AnimatedListState> _listNode;
  GlobalKey<ScaffoldState> _scaffoldNode;
  bool _hasSaved;

  @override
  void initState() {
    super.initState();
    f = File(widget.filePath);
    _sheet = ActionSheetDecoder.getInstance().decode(f.readAsStringSync());

    if (_sheet.actions.length == 0) {
      insertNewAction(0,
          item: ActionDescription('Click to edit this action.',
              const Duration(seconds: 10), const Duration()));
    }

    _listNode = GlobalKey<AnimatedListState>();
    _scaffoldNode = GlobalKey<ScaffoldState>();

    _hasSaved = true;
  }

  ActionDescription insertNewAction(int index, {ActionDescription item}) {
    if (item == null) {
      item = ActionDescription.EmptyTemplate;
    }

    _sheet.actions.insert(index, item);

    if (_listNode != null) {
      _listNode.currentState
          .insertItem(index, duration: const Duration(milliseconds: 300));
    }

    return item;
  }

  void removeAction(ActionDescription action) {
    int index = _sheet.actions.indexOf(action);

    _listNode.currentState.removeItem(index, (context, animation) {
      Widget transition = SizeTransition(
        child: editableActionCard(action, index + 1),
        sizeFactor: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
      );

      _sheet.actions.removeAt(index);

      return transition;
    }, duration: const Duration(milliseconds: 200));
  }

  Widget editableActionCard(ActionDescription action, int orderIndex) {
    return ActionCard(
      onPressed: (selectedAction, type) {
        final int indexToSave = _sheet.actions.indexOf(selectedAction);

        switch (type) {
          case ACIONCARD_ACION.INSERT_ABOVE:
            _hasSaved = false;

            insertNewAction(_sheet.actions.indexOf(selectedAction));
            Future.delayed(Duration(milliseconds: 200)).then((value) =>
                openEditDialog(ActionDescription.EmptyTemplate, indexToSave));
            break;
          case ACIONCARD_ACION.INSERT_BELOW:
            _hasSaved = false;

            Scrollable.ensureVisible(context);
            insertNewAction(_sheet.actions.indexOf(selectedAction) + 1);
            Future.delayed(Duration(milliseconds: 200)).then((value) =>
                openEditDialog(
                    ActionDescription.EmptyTemplate, indexToSave + 1));
            break;
          case ACIONCARD_ACION.DELETE:
            _hasSaved = false;

            removeAction(selectedAction);
            break;
          case ACIONCARD_ACION.SELECT:
            openEditDialog(action, indexToSave);
            break;
        }
      },
      heading:
          Text('$orderIndex.', style: Theme.of(context).textTheme.headline6),
      act: action,
    );
  }

  void openEditDialog(ActionDescription action, int indexToSave) {
    showCupertinoDialog<ActionDescription>(
        context: context,
        builder: (_) {
          return ActionEditDialog(action: action);
        }).then((act) {
      if (act != null) {
        setState(() {
          _sheet.actions[indexToSave] = act;
          _hasSaved = false;
        });
      }
    });
  }

  void saveFile() {
    _sheet.saveTo(f.path).then((value) {
      _scaffoldNode.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('File has been saved.'),
      ));
      _hasSaved = true;
    });
  }

  Future<bool> askForConfirmAndQuit() async {
    if (!_hasSaved) {
      CONFIRM_STATE state = await showCupertinoDialog<CONFIRM_STATE>(
          context: context,
          builder: (_) {
            return ConfirmQuitDialog();
          });
      if (state == CONFIRM_STATE.SAVE_AND_QUIT)
        saveFile();
      else if (state == CONFIRM_STATE.CANCEL) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: askForConfirmAndQuit,
      child: Scaffold(
        key: _scaffoldNode,
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: Text(f.path.split('/').last.split('.').first),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child:
                  IconButton(icon: Icon(Icons.save_alt), onPressed: saveFile),
            )
          ],
        ),
        body: AnimatedList(
          key: _listNode,
          initialItemCount: _sheet.actions.length,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            return SizeTransition(
                sizeFactor: Tween<double>(
                  begin: 0,
                  end: 1,
                ).animate(animation),
                child: editableActionCard(_sheet.actions[index], index + 1));
          },
        ),
      ),
    );
  }
}
