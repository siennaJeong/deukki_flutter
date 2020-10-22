
import 'package:flutter/material.dart';

class StageProvider with ChangeNotifier{
  bool isPlaying;
  int playCount;
  int selectedAnswerIndex;
  String selectedAnswer;
  double firstHeight, secondHeight;

  StageProvider() {
    this.isPlaying = false;
    this.playCount = 0;
    this.firstHeight = 0;
    this.secondHeight = 0;
    this.selectedAnswerIndex = -1;
  }

  void setPlaying(bool isPlaying) {
    this.isPlaying = isPlaying;
    notifyListeners();
  }

  void onSelectedAnswer(int index, String selectedAnswer) {
    this.selectedAnswerIndex = index;
    this.selectedAnswer = selectedAnswer;
    notifyListeners();
  }

  void setPlayCount() {
    this.playCount ++;
    notifyListeners();
  }

  void setFirstHeight(double firstHeight) {
    this.firstHeight = firstHeight;
    notifyListeners();
  }

  void setSecondHeight(double secondHeight) {
    this.secondHeight = secondHeight;
    notifyListeners();
  }
}