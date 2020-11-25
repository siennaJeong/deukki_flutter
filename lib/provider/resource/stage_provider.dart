
import 'dart:async';
import 'dart:io';

import 'package:deukki/data/model/learning_vo.dart';
import 'package:flutter/material.dart';

class StageProvider with ChangeNotifier{
  bool isPlaying;
  int playCount;
  List<int> selectAnswerIndex;
  List<String> selectedAnswer;
  double playRate;

  Timer _timer;
  int _learnTime;
  int stageIdx;
  int countCorrectAnswer;

  int level;
  int round;
  bool correct;
  int soundRepeat;
  int playPIdx;
  int selectPIdx;

  int oneTimeAnswerCount;

  List<Map> historyList;

  StageProvider() {
    this.isPlaying = false;
    this.playCount = 0;
    if(Platform.isIOS) {
      this.playRate = 1;
    }else {
      this.playRate = 0.8;
    }
    this.selectAnswerIndex = [];
    this.selectedAnswer = [];
    this._learnTime = 0;
    this.stageIdx = 0;
    this.countCorrectAnswer = 0;
    this.historyList = [];
    this.level = 1;
    this.round = 1;
    this.correct = false;
    this.selectPIdx = 0;
    this.playPIdx = 0;
    this.soundRepeat = 0;
    this.oneTimeAnswerCount = 0;
  }

  void setPlaying(bool isPlaying) {
    this.isPlaying = isPlaying;
    notifyListeners();
  }

  void onSelectedAnswer(int index, String selectedAnswer) {
    this.selectAnswerIndex.add(index);
    this.selectedAnswer.add(selectedAnswer);
    notifyListeners();
  }

  void setPlayCount() {
    this.playCount ++;
    notifyListeners();
  }

  void setPlayRate() {
    this.playRate = this.playRate + 0.15;
    notifyListeners();
  }

  void historyInit(int playPIdx) {
    this.correct = false;
    this.selectPIdx = 0;
    this.playPIdx = playPIdx;
    this.soundRepeat = 0;
    this.oneTimeAnswerCount = 0;
    notifyListeners();
  }

  void initSelectAnswer() {
    this.selectAnswerIndex = [];
    this.selectedAnswer = [];
    notifyListeners();
  }

  void setOneTimeAnswerCount() {
    this.oneTimeAnswerCount++;
    notifyListeners();
  }

  void setCorrect(bool correct) {
    this.correct = correct;
    notifyListeners();
  }

  void setSelectPIdx(int selectPIdx) {
    this.selectPIdx = selectPIdx;
    notifyListeners();
  }

  void setSoundRepeat() {
    this.soundRepeat++;
    notifyListeners();
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
    this.level++;
    notifyListeners();
  }

  void setStageIdx(int stageIdx) {
    this.stageIdx = stageIdx;
  }

  void startLearnTime() async {
    _timer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      _learnTime++;
    });
  }

  void stopLearnTime() async {
    _timer?.cancel();
  }

  void addHistory() {
    var historyVO = HistoryVO(
        this.level.toString(),
        this.round.toString(),
        this.correct ? 'true' : 'false',
        this.soundRepeat.toString(),
        this.playPIdx.toString(),
        this.selectPIdx.toString());
    historyList.add(historyVO.bodyJson());
  }

  LearningVO generateLearningRecord(int idx) {
    LearningVO learningVO = LearningVO(this._learnTime.toString(), this.countCorrectAnswer.toString(), idx.toString(), historyList);
    return learningVO;
  }

}