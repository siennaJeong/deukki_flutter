import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseWidget extends StatefulWidget{
  //Widget buildCupertinoWidget(BuildContext context);
  //Widget buildMaterialWidget(BuildContext context);
  @override
  Widget build(BuildContext context) {
    /*if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    }
    return buildMaterialWidget(context);*/
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
}