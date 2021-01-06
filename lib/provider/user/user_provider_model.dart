import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/learning_vo.dart';
import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/data/model/report_vo.dart';
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
  ReportVO weeklyReports;
  int bookmarkScore = 0;

  Future<void> checkSignUp(String authType, String authId, String fbUid) async {
    final checkSignUp = _userRepository.checkUserSignUp(authType, authId, fbUid);
    await value.checkSignUp.set(checkSignUp, notifyListeners);
  }

  Future<void> signUp(UserVO userVO, String authType, String authId, String fbUid, bool agreeMarketing, String marketingMethod, String phone) async {
    final signUp = _userRepository.signUp(userVO, authType, authId, fbUid, agreeMarketing, marketingMethod, phone);
    await value.signUp.set(signUp, notifyListeners);
  }

  Future<void> signOut(String authJWT) async {
    final signOut = _userRepository.signOut(authJWT);
    await value.signOut.set(signOut, notifyListeners);
  }

  Future<void> login(String authType, String authId, String fbUid) async {
    final login = _userRepository.login(authType, authId, fbUid);
    await value.login.set(login, notifyListeners);
  }

  Future<void> logout(String authJWT) async {
    final logout = _userRepository.logout(authJWT);
    await value.logout.set(logout, notifyListeners);
  }

  Future<void> recordLearning(String authJWT, String sentenceId, LearningVO learningVO) async {
    final recordLearn = _userRepository.recordLearning(authJWT, sentenceId, learningVO);
    await value.recordLearning.set(recordLearn, notifyListeners);
  }

  Future<void> updateBookmark(String authJWT, String sentenceId, int stageIdx) async {
    final updateBookmark = _userRepository.updateBookmark(authJWT, sentenceId, stageIdx);
    await value.updateBookmark.set(updateBookmark, notifyListeners);
    getBookmark(authJWT);
  }

  Future<void> getBookmark(String authJWT) async {
    final getBookmark = _userRepository.getBookmark(authJWT);
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
    getUserInfo.then((value) {
      userVOForHttp ??= value.asValue.value;
    });
    await value.getUserInfo.set(getUserInfo, notifyListeners);
  }

  Future<void> getProductList(String authJWT) async {
    final getProductList = _userRepository.getProductList(authJWT);
    getProductList.then((value) {
      productList = value.asValue.value;
    });
    await value.getProductList.set(getProductList, notifyListeners);
  }

  Future<void> updateMarketingAgree(String authJWT, String marketingMethod, bool agreement, String phone) async {
    final updateMarketingAgree = _userRepository.marketingAgreement(authJWT, marketingMethod, agreement, phone);
    await value.updateMarketingAgree.set(updateMarketingAgree, notifyListeners);
  }

  Future<void> getReports(String authJWT) async {
    final getReports = _userRepository.getReports(authJWT);
    getReports.then((value) {
      weeklyReports ??= value.asValue.value;
    });
    await value.getReports.set(getReports, notifyListeners);
  }

  Future<void> verifyToken(String authJWT) async {
    final verifyToken = _userRepository.verifyToken(authJWT);
    await value.verifyToken.set(verifyToken, notifyListeners);
  }

}