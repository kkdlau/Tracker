import 'package:Tracker/action_sheet/action_description.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionEditDialog extends StatefulWidget {
  final ActionDescription action;
  ActionEditDialog({Key key, this.action}) : super(key: key);

  @override
  _ActionEditDialogState createState() => _ActionEditDialogState();
}

class _ActionEditDialogState extends State<ActionEditDialog> {
  TextEditingController _descriptionController;
  TextEditingController _targetMinController;
  TextEditingController _targetSecController;
  TextEditingController _diffMinController;
  TextEditingController _diffSecController;
  String _errorMsg;

  @override
  void initState() {
    super.initState();

    _errorMsg = '';

    _descriptionController =
        TextEditingController(text: widget.action.description);

    _targetMinController = TextEditingController(
        text: widget.action.targetTime.inMinutes.toString());
    _targetSecController = TextEditingController(
        text: (widget.action.targetTime.inSeconds % 60).toString());

    _diffMinController = TextEditingController(
        text: widget.action.timeDiff.inMinutes.toString());
    _diffSecController = TextEditingController(
        text: (widget.action.timeDiff.inSeconds % 60).toString());
  }

  ActionDescription constructAction() {
    return ActionDescription(
        _descriptionController.text,
        Duration(
            seconds: int.parse(_targetMinController.text) * 60 +
                int.parse(_targetSecController.text)),
        Duration(
            seconds: int.parse(_diffMinController.text) * 60 +
                int.parse(_diffSecController.text)));
  }

  Widget _errorText() {
    if (_errorMsg.isEmpty)
      return const SizedBox();
    else
      return Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Align(
            child: Text(
              _errorMsg,
              style: TextStyle(color: Colors.red),
            ),
            alignment: Alignment.center,
          ));
  }

  int _calculateSeconds(TextEditingController minsController,
      TextEditingController secController) {
    return int.parse(minsController.text) * 60 + int.parse(secController.text);
  }

  void textfieldAssert(bool condition, String msgIfError) {
    if (!condition)
      setState(() {
        _errorMsg = msgIfError;
      });
  }

  bool validInput() {
    _errorMsg = '';

    textfieldAssert(
        _descriptionController.text.isNotEmpty, "Description cannot be empty.");
    textfieldAssert(int.parse(_targetMinController.text) >= 0,
        "Target time(Min) must be a positive number.");

    textfieldAssert(int.parse(_targetSecController.text) >= 0,
        "Target time(Sec) must be a positive number.");

    textfieldAssert(int.parse(_diffSecController.text) >= 0,
        "Difference time(Sec) must be a positive number.");

    return _errorMsg.isEmpty;
  }

  void saveAction() {
    if (validInput() && Navigator.canPop(context)) {
      Navigator.pop(
          context,
          ActionDescription(
              _descriptionController.text,
              Duration(
                  seconds: _calculateSeconds(
                      _targetMinController, _targetSecController)),
              Duration(
                  seconds: _calculateSeconds(
                      _diffMinController, _diffSecController))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
        data: CupertinoThemeData(brightness: Theme.of(context).brightness),
        child: CupertinoAlertDialog(
          title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text("Edit Action")),
          content: Builder(
            builder: (BuildContext context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _errorText(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Description:',
                    ),
                  ),
                  CupertinoTextField(controller: _descriptionController),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Text(
                        'Target time:',
                        textAlign: TextAlign.start,
                      )),
                      SizedBox(
                        child: CupertinoTextField(
                          keyboardType: TextInputType.number,
                          controller: _targetMinController,
                        ),
                        width: 40.0,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text('m :')),
                      SizedBox(
                        child: CupertinoTextField(
                          keyboardType: TextInputType.number,
                          controller: _targetSecController,
                        ),
                        width: 40.0,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text('s')),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Text(
                        'Time difference:',
                        textAlign: TextAlign.start,
                      )),
                      SizedBox(
                          child: CupertinoTextField(
                            controller: _diffMinController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9-]'))
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                          ),
                          width: 40.0),
                      Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text('m :')),
                      SizedBox(
                          child: CupertinoTextField(
                            controller: _diffSecController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9-]'))
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                          ),
                          width: 40.0),
                      Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text('s')),
                    ],
                  )
                ],
              );
            },
          ),
          actions: [
            CupertinoButton(child: Text("Save"), onPressed: saveAction),
            CupertinoButton(
                child: Text(
                  "Discard",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                })
          ],
        ));
  }
}
