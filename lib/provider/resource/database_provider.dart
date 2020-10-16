
import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  final DBHelper dbHelper;
  List<CategoryLargeVO> _categoryLargeList = [];
  List<CategoryMediumVO> _categoryMediumList = [];

  DataProvider(this._categoryLargeList, {this.dbHelper}) {
    if(dbHelper != null) {
      fetchAndSetLargeCategory();
    }
  }

  List<CategoryMediumVO> get categoryMediumList => [..._categoryMediumList];

  List<CategoryLargeVO> get categoryLargeList => [..._categoryLargeList];

  Future<void> fetchAndSetLargeCategory() async {
    if(dbHelper.database != null) {
      final largeCategoryList = await dbHelper.getCategories(TABLE_CATEGORY_LARGE);
      _categoryLargeList = largeCategoryList.map((items) => CategoryLargeVO.fromJson(items)).toList();
      print("large category list : " + _categoryLargeList[0].title);
      notifyListeners();
    }
  }
}