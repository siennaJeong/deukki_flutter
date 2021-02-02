
import 'dart:convert';

import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CategoryProvider with ChangeNotifier {
  static const String MEDIUM_KEY = "mediumCategory";
  final DBHelper dbHelper;
  final SharedHelper sharedHelper;
  final AudioPlayer audioPlayer;
  bool isBookmark;
  bool isRootBookmark;
  bool isPlaying;
  int playCount;
  int selectLargeIndex;
  int selectStageIndex;
  int selectStageIdx;
  int currentStageIndex;
  int premiumPopupCount;      //  5개의 stage 완료 시에 premium pop up 띄운다.
  double stepProgress;
  double stageAvgScore;
  String _largeId;
  String _sentenceTitle;
  CategoryMediumVO _categoryMediumVO;
  SentenceVO selectedSentence;
  PronunciationVO _rightPronunciation;
  List<CategoryLargeVO> _categoryLargeList = [];
  List<CategoryMediumVO> _categoryMediumList = [];
  List<SentenceVO> _sentenceList = [];
  List<StageVO> _stageList = [];
  List<PronunciationVO> _pronunciationList = [];
  List<PreScoreVO> _preScoreList;

  CategoryProvider(this._categoryLargeList, {this.dbHelper, this.sharedHelper, this.audioPlayer}) {
    this.isPlaying = false;
    this.playCount = 0;
    this.selectLargeIndex = -1;
    this.selectStageIndex = -1;
    this.selectStageIdx = -1;
    this.currentStageIndex = -1;
    this.isBookmark = false;
    this.stepProgress = 0.2;
    this.stageAvgScore = 0;
    this.premiumPopupCount = 0;
    this.isRootBookmark = false;
    if(this.dbHelper != null) {
      fetchAndSetLargeCategory();
    }
    if(this.audioPlayer != null) {
      _initAudioPlayer();
    }
  }

  List<CategoryMediumVO> get categoryMediumList => [..._categoryMediumList];
  List<CategoryLargeVO> get categoryLargeList => [..._categoryLargeList];
  List<SentenceVO> get sentenceList => [..._sentenceList];
  List<StageVO> get stageList => [..._stageList];
  List<PronunciationVO> get pronunciationList => [..._pronunciationList];
  List<PreScoreVO> get preScoreList => [..._preScoreList];

  getLargeId() => _largeId;
  getSentenceTitle() => _sentenceTitle;
  CategoryMediumVO getCurrentMedium() => _categoryMediumVO;
  PronunciationVO getRightPronun() => _rightPronunciation;

  setLargeId(String largeId) => _largeId = largeId;
  setSentenceTitle(String sentenceTitle) => _sentenceTitle = sentenceTitle;
  setCurrentMedium(CategoryMediumVO categoryMediumVO) => _categoryMediumVO = categoryMediumVO;
  setRightPronun(PronunciationVO rightPronun) => _rightPronunciation = rightPronun;

  Future<void> fetchAndSetLargeCategory() async {
    if(dbHelper.database != null && _categoryLargeList.length <= 0) {
      final largeList = await dbHelper.getCategories(TABLE_CATEGORY_LARGE);
      _categoryLargeList = largeList.map((items) => CategoryLargeVO.fromJson(items)).toList();
      notifyListeners();
    }
  }

  Future<void> setMediumCategory(String largeId) async {
    setLargeId(largeId);
    final mediumList = await dbHelper.getCategoryMedium(largeId);
    _categoryMediumList = mediumList.map((items) => dbHelper.mediumFromJson(items)).toList();
    if(sharedHelper.sharedPreference != null) {
      final sharedCategory = await sharedHelper.getStringSharedPref("${MEDIUM_KEY}_$selectLargeIndex");
      if(sharedCategory.isNotEmpty) {
        setCurrentMedium(CategoryMediumVO.fromJson(json.decode(sharedCategory)));
      }else {
        setCurrentMedium(_categoryMediumList[0]);
      }
    }
    notifyListeners();
  }

  Future<void> setSentence(list) async {
    this._sentenceList = list;
    notifyListeners();
  }

  Future<void> setStage(list) async {
    this._stageList = list;
    for(int i = 0 ; i < this._stageList.length ; i++) {
      if(i - 1 == -1) {
        if(this._stageList[i + 1].score == null) {
          this.selectStageIndex = i;
          this.currentStageIndex = i;
          this.selectStageIdx = this._stageList[i].stageIdx;
        }
      }else {
        if(this._stageList[i - 1].score != null && this._stageList[i].score == null) {
          this.selectStageIndex = i;
          this.currentStageIndex = i;
          this.selectStageIdx = this._stageList[i].stageIdx;
          break;
        }
      }
    }
  }

  Future<void> initPreScore() async {
    this._preScoreList ??= [PreScoreVO(0, true)];
    for(int i = 1 ; i <= this._stageList.length ; i++) {
      if(this._stageList[i - 1].score != null) {
        this._preScoreList?.add(PreScoreVO(i, true));
      }else {
        this._preScoreList?.add(PreScoreVO(i, false));
      }
    }
  }

  Future<void> setPreScore(list) async {
    this._preScoreList = list;
    notifyListeners();
  }

  void onSelectedLarge(int index) {
    this.selectLargeIndex = index;
    notifyListeners();
  }

  void onSelectedStage(int index, int stageIdx) {
    this.selectStageIndex = index;
    this.selectStageIdx = stageIdx;
    notifyListeners();
  }

  void onBookMark(bool isBookmark) {
    this.isBookmark = isBookmark;
    notifyListeners();
  }

  void onRootBookmark(bool isRootBookmark) {
    this.isRootBookmark = isRootBookmark;
    notifyListeners();
  }

  void setStepProgress() {
    this.stepProgress = this.stepProgress + 0.2;
    notifyListeners();
  }

  void initStepProgress() {
    this.stepProgress = 0.2;
    notifyListeners();
  }

  void onSelectedSentence(SentenceVO sentenceVO) {
    this.selectedSentence = sentenceVO;
    notifyListeners();
  }

  void updateScore(int acquiredScore, double score) {
    this.stageAvgScore = score;
    if(this.selectStageIndex != null) {
      final stageItem = this._stageList.firstWhere((element) => element.stage == (this.selectStageIndex + 1));
      stageItem.score = acquiredScore;
      setStage(this._stageList);
      notifyListeners();
    }
  }

  void updateStageAvgScore() {
    final sentenceItem = this.sentenceList.firstWhere((element) => element.id == (this.selectedSentence.id));
    sentenceItem.avgScore = this.stageAvgScore;
    setSentence(this.sentenceList);
    notifyListeners();
  }

  void updatePreScore() {
    final preScoreItem = this._preScoreList.firstWhere((element) => element.idx == this.selectStageIndex);
    preScoreItem.isPreScoreExist = true;
    setPreScore(this._preScoreList);
    notifyListeners();
  }

  Future<void> setPronunciationList(List<dynamic> pronunList, PronunciationVO rightPronunciation) async {
    if(this._pronunciationList.length > 0) {
      this._pronunciationList.clear();
    }
    setRightPronun(rightPronunciation);
    this._pronunciationList.add(rightPronunciation);
    pronunList.forEach((element) {
      PronunciationVO pronunciationVO = PronunciationVO.fromJson(element);
      this._pronunciationList.add(pronunciationVO);
    });
    notifyListeners();
  }

  Future<void> saveCategory(CategoryMediumVO mediumVO) async {
    sharedHelper.setStringSharedPref("${MEDIUM_KEY}_$selectLargeIndex", json.encode(mediumVO));
  }

  void setPlaying(bool isPlaying) {
    this.isPlaying = isPlaying;
    notifyListeners();
  }

  void setPlayCount() {
    this.playCount ++;
    notifyListeners();
  }

  void _initAudioPlayer() async {
    this.audioPlayer.playerStateStream.listen((event) async {
      switch(event.processingState) {
        case ProcessingState.completed:
          await this.audioPlayer.pause();
          setPlaying(false);
          setPlayCount();
          break;
        case ProcessingState.idle:
          print("audio player state => idle");
          break;
        case ProcessingState.loading:
          print("audio player state => loading");
          break;
        case ProcessingState.buffering:
          print("audio player state => buffering");
          break;
        case ProcessingState.ready:
          print("audio player state => ready");
          break;
      }
    });

  }

  void play(String filePath, double speed) async {
    await this.audioPlayer.setFilePath(filePath);
    await this.audioPlayer.setSpeed(speed);
    await this.audioPlayer.play();
  }

  void setPremiumPopupCount() {
    this.premiumPopupCount++;
  }

}