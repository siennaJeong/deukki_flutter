
import 'package:flutter/material.dart';

class RecordProvider with ChangeNotifier{
  bool isRecord;

  RecordProvider(){
    this.isRecord = false;
  }

  void setIsRecord(bool isRecord) {
    this.isRecord = isRecord;
    notifyListeners();
  }
}