
import 'package:flutter/material.dart';

class RecordProvider with ChangeNotifier{
  bool isRecord;
  int roundCount;

  RecordProvider(){
    this.isRecord = false;
    this.roundCount = 0;
  }

  void setIsRecord(bool isRecord) {
    this.isRecord = isRecord;
    notifyListeners();
  }

  void setRoundCount() {
    this.roundCount++;
    notifyListeners();
  }
}