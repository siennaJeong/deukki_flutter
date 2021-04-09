
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CommonRaisedButton extends StatefulWidget {
  final Color textColor, buttonColor, borderColor;
  final String buttonText;
  final double fontSize;
  VoidCallback voidCallback;

  CommonRaisedButton({
    @required this.textColor,
    @required this.buttonColor,
    @required this.borderColor,
    @required this.buttonText,
    @required this.fontSize,
    @required this.voidCallback
  });

  @override
  _CommonRaisedButtonState createState() => _CommonRaisedButtonState();
}

class _CommonRaisedButtonState extends State<CommonRaisedButton> {
  Color _buttonColor, _borderColor, _textColor;
  String _buttonText;
  double _fontSize;
  VoidCallback _voidCallback;

  @override
  void initState() {
    super.initState();
    _buttonColor = widget.buttonColor;
    _borderColor = widget.borderColor;
    _textColor = widget.textColor;
    _buttonText = widget.buttonText;
    _fontSize = widget.fontSize;
    _voidCallback = widget.voidCallback;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(14),
          primary: _buttonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              side: BorderSide(
                  color: _borderColor,
                  width: 2.0
              )
          ),
        ),
        child: Text(
          _buttonText,
          style: TextStyle(
              color: _textColor,
              fontSize: _fontSize,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700
          ),
        ),
        onPressed: () => { _voidCallback.call() }
    );
  }
}

