
import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final DBHelper dbHelper;
  int selectIndex;
  String largeId;
  String firstMediumId;
  List<CategoryLargeVO> _categoryLargeList = [];
  List<CategoryMediumVO> _categoryMediumList = [];
  List<CategoryMediumVO> _categorySmallList = [];

  CategoryProvider(this._categoryLargeList, {this.dbHelper}) {
    this.selectIndex = -1;
    if(dbHelper != null) {
      fetchAndSetLargeCategory();
    }
  }

  List<CategoryMediumVO> get categoryMediumList => [..._categoryMediumList];
  List<CategoryLargeVO> get categoryLargeList => [..._categoryLargeList];
  List<CategoryMediumVO> get categorySmallList => [..._categorySmallList];

  Future<void> fetchAndSetLargeCategory() async {
    if(dbHelper.database != null) {
      final largeList = await dbHelper.getCategories(TABLE_CATEGORY_LARGE);
      _categoryLargeList = largeList.map((items) => CategoryLargeVO.fromJson(items)).toList();
      notifyListeners();
    }
  }

  Future<void> setMediumCategory(String largeId) async {
    this.largeId = largeId;
    final mediumList = await dbHelper.getCategoryMedium(largeId);
    _categoryMediumList = mediumList.map((items) => dbHelper.mediumFromJson(items)).toList();
    firstMediumId = _categoryMediumList[0].id;
    notifyListeners();
  }

  Future<void> setSmallCategory(list) async {
    this._categorySmallList = list;
    notifyListeners();
  }

  void onSelected(int index) {
    this.selectIndex = index;
    notifyListeners();
  }

}