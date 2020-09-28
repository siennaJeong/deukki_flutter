import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonRaisedButton extends StatelessWidget {
  final String buttonText, routeName;
  final Color buttonColor, textColor, borderColor;
  final double fontSize;

  CommonRaisedButton(this.buttonText, this.routeName, this.buttonColor, this.textColor, this.borderColor, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 14, right: 14, top: 13, bottom: 15),
      color: buttonColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          side: BorderSide(
              color: borderColor,
              width: 2.0
          )
      ),
      child: Text(
        buttonText,
        style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontFamily: "TmoneyRound",
            fontWeight: FontWeight.w700
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, routeName),
    );
  }

}
