import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateFileDialog extends StatefulWidget {
  final List<String> usedFileAlias;
  final String fileType;
  CreateFileDialog({Key key, this.usedFileAlias, this.fileType})
      : super(key: key);

  @override
  _CreateFileDialogState createState() => _CreateFileDialogState();
}

class _CreateFileDialogState extends State<CreateFileDialog> {
  TextEditingController _controller;
  String _errorMsg;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _errorMsg = '';
  }

  String _inputValidationMsg(String input) {
    if (input.isEmpty)
      return 'Please enter file name to create.';
    else if (widget.usedFileAlias.contains(input))
      return 'You\'ve already created a file with this name.';
    else if (input.contains(RegExp(r'/[-!$%^&*()_+|~=`{}\[\]:"<>?;,.\/]/')))
      return 'File alias cannot contain any symbol.';
    return '';
  }

  Widget _erroMsgWidget() {
    return _errorMsg.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _errorMsg,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.red),
            ),
          );
  }

  Widget _cancelButton() {
    return CupertinoButton(
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, null);
        }
      },
      child: Text('Cancel'),
    );
  }

  Widget _doneButton() {
    return CupertinoButton(
      onPressed: () {
        _errorMsg = _inputValidationMsg(_controller.text);
        if (_errorMsg == '') {
          if (Navigator.canPop(context)) {
            Navigator.pop(context, _controller.text);
          }
        } else {
          setState(() {});
        }
      },
      child: Text('Done'),
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text('Create a new ${widget.fileType}',
          style: Theme.of(context).textTheme.subtitle1),
    );
  }

  Widget _fileAliasTextField() {
    return CupertinoTextField(
      style: Theme.of(context).inputDecorationTheme.errorStyle,
      controller: _controller,
      placeholder: 'Enter sheet name...',
      onChanged: (input) {
        setState(() {
          _errorMsg = _inputValidationMsg(input);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(brightness: Theme.of(context).brightness),
      child: CupertinoAlertDialog(
        title: _titleWidget(),
        content: Column(
          children: [_erroMsgWidget(), _fileAliasTextField()],
        ),
        actions: [_doneButton(), _cancelButton()],
      ),
    );
  }
}
