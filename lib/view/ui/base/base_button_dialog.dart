import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseButtonDialog extends StatefulWidget {
  final String content;
  final String btnOk, btnCancel;
  BaseButtonDialog({@required this.content, @required this.btnOk, @required this.btnCancel});

  @override
  _BaseButtonDialogState createState() => _BaseButtonDialogState();
}

class _BaseButtonDialogState extends State<BaseButtonDialog> {
  String _content;
  String _btnOk, _btnCancel;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
    _btnOk = widget.btnOk;
    _btnCancel = widget.btnCancel;
  }
  void _finishApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0)
      ),
      child: Container(
        height: 250,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(30),
              child: Text(
                  _content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2
              ),
            ),
            Container(
              width: 270,
              margin: EdgeInsets.only(right: 70, left: 70),
              child: CommonRaisedButton(
                textColor: Colors.white,
                buttonColor: MainColors.purple_100,
                borderColor: MainColors.purple_100,
                buttonText: _btnOk,
                fontSize: 16,
                voidCallback: null,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 270,
              margin: EdgeInsets.only(right: 70, left: 70),
              child: CommonRaisedButton(
                  textColor: MainColors.purple_100,
                  buttonColor: Colors.white,
                  borderColor: MainColors.purple_100,
                  buttonText: _btnCancel,
                  fontSize: 16,
                  voidCallback: _finishApp
              ),
            ),
          ],
        ),
      )
    );
  }
}
