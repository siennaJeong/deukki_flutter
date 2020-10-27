
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:flutter/material.dart';

class MyPageProvider with ChangeNotifier {
  int _selectButtonIndex;
  List<BookmarkVO> _bookmarkList = [];

  MyPageProvider() {
    this._selectButtonIndex = 0;
  }

  getButtonIndex() => _selectButtonIndex;

  setButtonIndex(int selectButtonIndex) {
    this._selectButtonIndex = selectButtonIndex;
    notifyListeners();
  }

  List<BookmarkVO> get bookmarkList => [..._bookmarkList];

  void setBookmark(list) {
    this._bookmarkList = list;
    notifyListeners();
  }
}