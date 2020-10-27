
import 'dart:async';

import 'package:flutter/material.dart';

class StageProvider with ChangeNotifier{
  bool isPlaying;
  int playCount, answerCount, selectedAnswerIndex;
  double firstHeight, secondHeight, playRate;
  String selectedAnswer;

  Timer _timer;
  var _learnTime;

  StageProvider() {
    this.isPlaying = false;
    this.playCount = 0;
    this.answerCount = 0;
    this.firstHeight = 0;
    this.secondHeight = 0;
    this.playRate = 1.0;
    this.selectedAnswerIndex = -1;
    this._learnTime = 0;
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

  void setAnswerCount() {
    this.answerCount++;
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

  void setPlayRate() {
    this.playRate = this.playRate + 0.25;
    notifyListeners();
  }

  void startLearnTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _learnTime++;
    });
  }

  void stopLearnTime() {
    _timer?.cancel();
  }
}