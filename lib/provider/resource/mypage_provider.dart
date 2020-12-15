
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:flutter/material.dart';

class MyPageProvider with ChangeNotifier {
  int _selectButtonIndex;
  List<BookmarkVO> _bookmarkList = [];

  bool _isPaying;

  MyPageProvider() {
    this._isPaying = false;
    this._selectButtonIndex = 0;
  }

  getIsPaying() => _isPaying;
  setIsPaying(bool isPaying) {
    _isPaying = isPaying;
    notifyListeners();
  }

  initButtonIndex(int initIndex) {
    this._selectButtonIndex = initIndex;
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