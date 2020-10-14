import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:path/path.dart';

class BaseButtonDialog extends StatelessWidget {
  BaseButtonDialog({@required String content, @required String btnOk, @required String btnCancel})
      : assert(content != null && btnOk != null && btnCancel != null),
        _content = content,
        _btnOk = btnOk,
        _btnCancel = btnCancel;

  final String _content;
  final String _btnOk, _btnCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0)
        ),
        content: Text(
            _content,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2
        )
    );
  }

}
