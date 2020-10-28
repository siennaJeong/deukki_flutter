
import 'dart:async';

import 'package:deukki/data/model/learning_vo.dart';
import 'package:flutter/material.dart';

class StageProvider with ChangeNotifier{
  bool isPlaying;
  int playCount, selectedAnswerIndex;
  double playRate;
  String selectedAnswer;

  Timer _timer;
  var _learnTime;
  int stageIdx;
  int countCorrectAnswer;

  int level;
  int round;
  bool correct;
  int soundRepeat;
  int playPIdx;
  int selectPIdx;

  List<HistoryVO> historyList;

  StageProvider() {
    this.isPlaying = false;
    this.playCount = 0;
    this.playRate = 1.0;
    this.selectedAnswerIndex = -1;
    this._learnTime = 0;
    this.stageIdx = 0;
    this.countCorrectAnswer = 0;
    this.historyList = [];
    this.level = 1;
    this.round = 1;
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

  void setPlayRate() {
    this.playRate = this.playRate + 0.25;
    notifyListeners();
  }

  void historyInit(int playPIdx) {
    this.correct = false;
    this.selectPIdx = 0;
    this.playPIdx = playPIdx;
    this.soundRepeat = 0;
  }

  void setCorrect(bool correct, int selectPIdx) {
    this.correct = correct;
    this.selectPIdx = selectPIdx;
    notifyListeners();
  }

  void setSoundRepeat() {
    this.soundRepeat++;
  }

  void setPlayPIdx(int pIdx) {
    this.playPIdx = pIdx;
  }

  void setCountCorrectAnswer() {
    this.countCorrectAnswer++;
  }

  void setRound() {
    this.round++;
    notifyListeners();
  }

  void setLevel() {
    this.level++;   //  속
    notifyListeners();
  }

  void setStageIdx(int stageIdx) {
    this.stageIdx = stageIdx;
  }

  void startLearnTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _learnTime++;
    });
  }

  void stopLearnTime() {
    _timer?.cancel();
  }

  void addHistory() {
    HistoryVO historyVO = HistoryVO(this.level, this.round, this.correct, this.soundRepeat, this.playPIdx, this.selectPIdx);
    print("add history : " + historyVO.toString());
    historyList.add(historyVO);
  }

}