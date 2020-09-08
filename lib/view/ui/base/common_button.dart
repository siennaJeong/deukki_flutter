
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonRaisedButton extends StatelessWidget {
  final String buttonText;
  final String routeName;
  final bool isWhiteButton;

  CommonRaisedButton(this.buttonText, this.routeName, this.isWhiteButton);

  @override
  Widget build(BuildContext context) {
    return isWhiteButton ? setRaisedButton(Colors.white, MainColors().purple_100, context) : setRaisedButton(MainColors().purple_100, Colors.white, context);
  }

  Widget setRaisedButton(Color buttonColor, Color textColor, BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 14, right: 14, top: 13, bottom: 15),
      color: buttonColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          side: BorderSide(
              color: textColor,
              width: 2.0
          )
      ),
      child: Text(
        buttonText,
        style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontFamily: "TmoneyRound",
            fontWeight: FontWeight.w700
        ),
      ),
      onPressed: () => RouteNavigator(context).navigatePushName(routeName),
    );
  }
}
