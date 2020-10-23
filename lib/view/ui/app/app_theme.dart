import 'package:deukki/view/values/colors.dart';
import 'package:flutter/material.dart';
class AppThemeDataFactory {
  static ThemeData prepareThemeData() => ThemeData(
    primaryColor: MainColors.yellow_100,
    accentColor: MainColors.grey_100,
    backgroundColor: Colors.white,
    buttonColor: MainColors.purple_100,
    cardColor: MainColors.none_color,
    fontFamily: 'TmoneyRound',
    textTheme: TextTheme(
      headline3: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: Colors.white
      ),
      headline4: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: MainColors.grey_100
      ),
      subtitle1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: MainColors.grey_100
      ),
      subtitle2: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: MainColors.grey_70
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontFamily: 'NotoSansKR',
        fontWeight: FontWeight.w400,
        color: Colors.black
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        fontFamily: 'NotoSansKR',
        fontWeight: FontWeight.w400,
        color: MainColors.grey_100
      )
    )
  );
}