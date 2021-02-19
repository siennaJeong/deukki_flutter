import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/learning_vo.dart';
import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/data/model/report_vo.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/repository/user/user_repository.dart';
import 'package:deukki/data/repository/user/user_rest_repository.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/provider_model.dart';
import 'package:deukki/provider/user/user_provider_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProviderModel extends ProviderModel<UserProviderState> {
  DBHelper _dbHelper;
  SharedHelper _sharedHelper;

  UserProviderModel({@required UserRepository userRepository, @required DBHelper dbHelper, @required SharedHelper sharedHelper})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _dbHelper = dbHelper,
        _sharedHelper = sharedHelper,
        super(UserProviderState());

  factory UserProviderModel.build() => UserProviderModel(userRepository: UserRestRepository(), dbHelper: DBHelper(), sharedHelper: SharedHelper());
  final UserRepository _userRepository;
  static const String PREMIUM_POPUP = "premiumPopup";
  static const String STAGE_GUIDE = "stageGuide";
  static const String LEARN_GUIDE = "learnGuide";
  List<BookmarkVO> currentBookmarkList = [];
  List<ProductionVO> productList = [];
  List<ProductionVO> trialProductList = [];
  UserVOForHttp userVOForHttp;
  ReportVO weeklyReports;
  int bookmarkScore = 0;
  int premiumPopupShow = 0;
  int stageGuide, learnGuide = 0;

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
    userVOForHttp = null;
  }

  Future<void> login(String authType, String authId, String fbUid) async {
    final login = _userRepository.login(authType, authId, fbUid);
    await value.login.set(login, notifyListeners);
  }

  Future<void> logout(String authJWT) async {
    final logout = _userRepository.logout(authJWT);
    await value.logout.set(logout, notifyListeners);
    userVOForHttp = null;
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

  Future<void> getUserInfo(String authJWT, AuthServiceAdapter authServiceAdapter) async {
    final getUserInfo = _userRepository.getUserInfo(authJWT);
    getUserInfo.then((value) {
      userVOForHttp ??= value.asValue.value;
      if(authServiceAdapter.userVO.premium != userVOForHttp.premium) {
        authServiceAdapter.userVO.premium = userVOForHttp.premium;
        authServiceAdapter.dbHelper.updateUser(authServiceAdapter.userVO, 0);
      }
    });
    await value.getUserInfo.set(getUserInfo, notifyListeners);
  }

  Future<void> getProductList(String authJWT) async {
    final getProductList = _userRepository.getProductList(authJWT);
    getProductList.then((value) {
      for(int i = 0 ; i < value.asValue.value.length ; i++) {
        if(value.asValue.value[i].trial == 1) {
          trialProductList.add(value.asValue.value[i]);
        }else {
          productList.add(value.asValue.value[i]);
        }
      }
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

  Future<void> saveDeviceInfo(String authJWT, String platform, String deviceId, String deviceModel, String manufacturer, String osVersion, String appVersion, String fcmToken) async {
    final saveDeviceInfo = _userRepository.saveDeviceInfo(authJWT, platform, deviceId, deviceModel, manufacturer, osVersion, appVersion, fcmToken);
    await value.saveDeviceInfo.set(saveDeviceInfo, notifyListeners);
  }

  Future<void> getPremiumPopup() async {
    if(_sharedHelper != null) {
      premiumPopupShow = await _sharedHelper.getIntSharedPref(PREMIUM_POPUP);
    }
  }

  Future<void> getStageGuide() async {
    if(_sharedHelper != null) {
      stageGuide = await _sharedHelper.getIntSharedPref(STAGE_GUIDE);
    }
  }

  Future<void> getLearnGuide() async {
    if(_sharedHelper != null) {
      learnGuide = await _sharedHelper.getIntSharedPref(LEARN_GUIDE);
    }
  }

  void setUserPremium(String expiredDate) async {
    userVOForHttp.premium = 1;
    userVOForHttp.premiumEndAt = expiredDate;
  }

  void setPremiumPopupShow() async {
    await _sharedHelper.setIntSharedPref(PREMIUM_POPUP, 1);
    getPremiumPopup();
  }

  void setStageGuide() async {
    await _sharedHelper.setIntSharedPref(STAGE_GUIDE, 1);
    getStageGuide();
  }

  void setLearnGuide() async {
    await _sharedHelper.setIntSharedPref(LEARN_GUIDE, 1);
    getLearnGuide();
  }
}