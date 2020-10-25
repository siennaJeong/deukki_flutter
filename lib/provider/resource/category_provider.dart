
import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final DBHelper dbHelper;
  bool isBookmark;
  int selectLargeIndex;
  int selectStageIndex;
  int stageScore;
  double stepProgress;
  String _largeId;
  String _mediumId;
  String _mediumTitle;
  String _sentenceTitle;
  SentenceVO selectedSentence;
  PronunciationVO _rightPronunciation;
  List<CategoryLargeVO> _categoryLargeList = [];
  List<CategoryMediumVO> _categoryMediumList = [];
  List<SentenceVO> _sentenceList = [];
  List<StageVO> _stageList = [];
  List<PronunciationVO> _pronunciationList = [];

  CategoryProvider(this._categoryLargeList, {this.dbHelper}) {
    this.selectLargeIndex = -1;
    this.selectStageIndex = -1;
    this.isBookmark = false;
    this.stepProgress = 0.2;
    this.stageScore = 0;
    if(dbHelper != null) {
      fetchAndSetLargeCategory();
    }
  }

  List<CategoryMediumVO> get categoryMediumList => [..._categoryMediumList];
  List<CategoryLargeVO> get categoryLargeList => [..._categoryLargeList];
  List<SentenceVO> get sentenceList => [..._sentenceList];
  List<StageVO> get stageList => [..._stageList];
  List<PronunciationVO> get pronunciationList => [..._pronunciationList];

  getLargeId() => _largeId;
  getMediumId() => _mediumId;
  getMediumTitle() => _mediumTitle;
  getSentenceTitle() => _sentenceTitle;
  PronunciationVO getRightPronun() => _rightPronunciation;

  setLargeId(String largeId) => _largeId = largeId;
  setMediumId(String mediumId) => _mediumId = mediumId;
  setMediumTitle(String mediumTitle) => _mediumTitle = mediumTitle;
  setSentenceTitle(String sentenceTitle) => _sentenceTitle = sentenceTitle;
  setRightPronun(PronunciationVO rightPronun) => _rightPronunciation = rightPronun;

  Future<void> fetchAndSetLargeCategory() async {
    if(dbHelper.database != null) {
      final largeList = await dbHelper.getCategories(TABLE_CATEGORY_LARGE);
      _categoryLargeList = largeList.map((items) => CategoryLargeVO.fromJson(items)).toList();
      notifyListeners();
    }
  }

  Future<void> setMediumCategory(String largeId) async {
    setLargeId(largeId);
    final mediumList = await dbHelper.getCategoryMedium(largeId);
    _categoryMediumList = mediumList.map((items) => dbHelper.mediumFromJson(items)).toList();
    setMediumId(_categoryMediumList[0].id);
    setMediumTitle(_categoryMediumList[0].title);
    notifyListeners();
  }

  Future<void> setSentence(list) async {
    this._sentenceList = list;
    notifyListeners();
  }

  Future<void> setStage(list) async {
    this._stageList = list;
    notifyListeners();
  }

  void onSelectedLarge(int index) {
    this.selectLargeIndex = index;
    notifyListeners();
  }

  void onSelectedStage(int index) {
    this.selectStageIndex = index;
    notifyListeners();
  }

  void onBookMark(bool isBookmark) {
    this.isBookmark = isBookmark;
    notifyListeners();
  }

  void setStepProgress() {
    this.stepProgress = this.stepProgress + 0.2;
    notifyListeners();
  }

  void onSelectedSentence(SentenceVO sentenceVO) {
    this.selectedSentence = sentenceVO;
    notifyListeners();
  }

  void setStageScore(int stageScore) {
    this.stageScore = stageScore;
    notifyListeners();
  }

  void updateScore(int score) {
    if(this.selectStageIndex != null && this.stageScore > 0) {
      final stageItem = this._stageList.firstWhere((element) => element.stage == (this.selectStageIndex + 1));
      stageItem.score = score;
      setStage(this._stageList);
      notifyListeners();
    }
  }

  Future<void> setPronunciationList(List<dynamic> pronunList, PronunciationVO rightPronunciation) async {
    print("set pronuncation list");
    if(this._pronunciationList.length > 0) {
      this._pronunciationList.clear();
    }
    setRightPronun(rightPronunciation);
    pronunList.forEach((element) {
      PronunciationVO pronunciationVO = PronunciationVO.fromJson(element);
      this._pronunciationList.add(pronunciationVO);
    });
    this._pronunciationList.add(rightPronunciation);
    this._pronunciationList.shuffle();
    notifyListeners();
  }

}