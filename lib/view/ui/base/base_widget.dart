import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
}