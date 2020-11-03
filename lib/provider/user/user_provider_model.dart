import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/learning_vo.dart';
import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/repository/user/user_repository.dart';
import 'package:deukki/data/repository/user/user_rest_repository.dart';
import 'package:deukki/provider/provider_model.dart';
import 'package:deukki/provider/user/user_provider_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProviderModel extends ProviderModel<UserProviderState> {
  UserProviderModel({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(UserProviderState());

  factory UserProviderModel.build() => UserProviderModel(userRepository: UserRestRepository());
  final UserRepository _userRepository;
  List<BookmarkVO> currentBookmarkList = [];
  List<ProductionVO> productList = [];
  UserVOForHttp userVOForHttp;
  int bookmarkScore = 0;

  Future<void> checkSignUp(String authType, String authId) async {
    final checkSignUp = _userRepository.checkUserSignUp(authType, authId);
    await value.checkSignUp.set(checkSignUp, notifyListeners);
  }

  Future<void> signUp(UserVO userVO, String authType, String authId, bool agreeMarketing, String marketingMethod) async {
    final signUp = _userRepository.signUp(userVO, authType, authId, agreeMarketing, marketingMethod);
    await value.signUp.set(signUp, notifyListeners);
  }

  Future<void> signOut(String authJWT) async {
    final signOut = _userRepository.signOut(authJWT);
    await value.signOut.set(signOut, notifyListeners);
  }

  Future<void> login(String authType, String authId) async {
    final login = _userRepository.login(authType, authId);
    print("login");
    await value.login.set(login, notifyListeners);
  }

  Future<void> logout(String authJWT) async {
    final logout = _userRepository.logout(authJWT);
    await value.logout.set(logout, notifyListeners);
  }

  Future<void> recordLearning(String authJWT, String sentenceId, LearningVO learningVO) async {
    final recordLearn = _userRepository.recordLearning(authJWT, sentenceId, learningVO);
    recordLearn.then((value) {
      print("record learn result : " + value.asValue.value.result.toString());
    });

    await value.recordLearning.set(recordLearn, notifyListeners);
  }

  Future<void> updateBookmark(String authJWT, String sentenceId, int stageIdx) async {
    final updateBookmark = _userRepository.updateBookmark(authJWT, sentenceId, stageIdx);
    await value.updateBookmark.set(updateBookmark, notifyListeners);
    getBookmark(authJWT);
  }

  Future<void> getBookmark(String authJWT) async {
    final getBookmark = _userRepository.getBookmark(authJWT);
    print("get book mark");
    getBookmark.then((value) {
      setCurrentBookmarkList(value.asValue.value);
    });
    await value.getBookmark.set(getBookmark, notifyListeners);
  }

  Future<void> deleteBookmark(String authJWT, int bookmarkIdx) async {
    final deleteBookmark = _userRepository.deleteBookmark(authJWT, bookmarkIdx);
    await value.deleteBookmark.set(deleteBookmark, notifyListeners);
  }

  void setCurrentBookmarkList(list) {
    this.currentBookmarkList = list;
    notifyListeners();
  }

  void setBookmarkScore(int score) {

  }

  Future<void> getUserInfo(String authJWT) async {
    final getUserInfo = _userRepository.getUserInfo(authJWT);
    print("get user info");
    getUserInfo.then((value) {
      userVOForHttp ??= value.asValue.value;
    });
    await value.getUserInfo.set(getUserInfo, notifyListeners);
  }

  Future<void> getProductList(String authJWT) async {
    final getProductList = _userRepository.getProductList(authJWT);
    print("get product list");
    getProductList.then((value) {
      productList = value.asValue.value;
    });
    await value.getProductList.set(getProductList, notifyListeners);
  }

}