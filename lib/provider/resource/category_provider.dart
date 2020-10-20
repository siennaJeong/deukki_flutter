
import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final DBHelper dbHelper;
  int selectLargeIndex;
  int selectStageIndex;
  String _largeId;
  String _mediumId;
  String _mediumTitle;
  List<CategoryLargeVO> _categoryLargeList = [];
  List<CategoryMediumVO> _categoryMediumList = [];
  List<SentenceVO> _sentenceList = [];
  List<StageVO> _stageList = [];

  CategoryProvider(this._categoryLargeList, {this.dbHelper}) {
    this.selectLargeIndex = -1;
    this.selectStageIndex = -1;
    if(dbHelper != null) {
      fetchAndSetLargeCategory();
    }
  }

  List<CategoryMediumVO> get categoryMediumList => [..._categoryMediumList];
  List<CategoryLargeVO> get categoryLargeList => [..._categoryLargeList];
  List<SentenceVO> get sentenceList => [..._sentenceList];
  List<StageVO> get stageList => [..._stageList];

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



  getLargeId() => _largeId;
  getMediumId() => _mediumId;
  getMediumTitle() => _mediumTitle;

  setLargeId(String largeId) => _largeId = largeId;
  setMediumId(String mediumId) => _mediumId = mediumId;
  setMediumTitle(String mediumTitle) => _mediumTitle = mediumTitle;

}