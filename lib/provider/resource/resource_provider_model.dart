
import 'dart:io';

import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/repository/category/category_repository.dart';
import 'package:deukki/data/repository/category/category_rest_repository.dart';
import 'package:deukki/data/repository/version/version_repository.dart';
import 'package:deukki/data/repository/version/version_rest_repository.dart';
import 'package:deukki/provider/provider_model.dart';
import 'package:deukki/provider/resource/resource_provider_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

class ResourceProviderModel extends ProviderModel<ResourceProviderState> {
  ResourceProviderModel({
    @required VersionRepository versionRepository,
    @required CategoryRepository categoryRepository,
    @required DBHelper dbHelper})
      : assert(versionRepository != null && categoryRepository != null),
        _versionRepository = versionRepository,
        _categoryRepository = categoryRepository,
        _dbHelper = dbHelper,
        super(ResourceProviderState());

  factory ResourceProviderModel.build() =>
      ResourceProviderModel(
          versionRepository: VersionRestRepository(),
          categoryRepository: CategoryRestRepository(),
          dbHelper: DBHelper()
      );
  final VersionRepository _versionRepository;
  final CategoryRepository _categoryRepository;
  final DBHelper _dbHelper;
  PackageInfo _packageInfo;
  bool requireInstall = false;

  Future<void> _initData() async {
    final initData = _versionRepository.initData();
    initData.then((value) {
      final initResult = value.asValue.value.result;
      _dbHelper.insertCategoryLarge(initResult['largeCategories']);
      _dbHelper.insertFaq(initResult['faq']);
      for(int i = 0 ; i < initResult['largeCategories'].length ; i++) {
        _dbHelper.insertCategoryMedium(initResult['mediumCategories'][i][0], initResult['mediumCategories'][i][1]);
      }
    });
  }

  Future<void> checkAllVersion() async {
    final checkAllVersion = _versionRepository.checkAllVersion();
    final dbVersion = await _dbHelper.getVersion();
    checkAllVersion.then((value) {
      final versionResult = value.asValue.value.result;
      final versionResultApp = versionResult[VersionRepository.APP_VERSION] as Map<String, dynamic>;
      final versionResultCategory = versionResult[VersionRepository.CATEGORY_VERSION] as Map<String, dynamic>;
      final versionResultFaq = versionResult[VersionRepository.FAQ_VERSION] as Map<String, dynamic>;
      if(dbVersion == null) {
        _dbHelper.insertVersion(
            versionResultApp[VersionRepository.APP_VERSION],
            versionResultCategory[VersionRepository.CATEGORY_LARGE_VERSION],
            versionResultCategory[VersionRepository.CATEGORY_MEDIUM_VERSION],
            versionResultCategory[VersionRepository.CATEGORY_SMALL_VERSION],
            versionResultFaq[VersionRepository.VERSION]
        );
        _initData();
      }else {
        for(int i = 1 ; i < dbVersion.length ; i++) {
          if(dbVersion.elementAt(i).values.elementAt(1) == VersionRepository.CATEGORY_LARGE_VERSION &&
          dbVersion.elementAt(i).values.elementAt(2) < versionResultCategory[VersionRepository.CATEGORY_LARGE_VERSION]) {
            print("large category update");
           _dbHelper.deleteAllResource().then((value) {
             _initData();
           });
          }
          if(dbVersion.elementAt(i).values.elementAt(1) == VersionRepository.CATEGORY_MEDIUM_VERSION &&
          dbVersion.elementAt(i).values.elementAt(2) < versionResultCategory[VersionRepository.CATEGORY_MEDIUM_VERSION]) {
            print("medium category update");
            _dbHelper.deleteAllResource().then((value) {
              _initData();
            });
          }
          if(dbVersion.elementAt(i).values.elementAt(1) == VersionRepository.FAQ_VERSION &&
          dbVersion.elementAt(i).values.elementAt(2) < versionResultFaq[VersionRepository.VERSION]) {
            print("faq update");
            _dbHelper.deleteAllResource().then((value) {
              _initData();
            });
          }
        }
      }
    });
    await value.checkAllVersion.set(checkAllVersion, notifyListeners);
  }

  Future<void> checkAppVersion() async {
    final checkAppVersion = _versionRepository.checkAppVersion();
    await value.checkAppVersion.set(checkAppVersion, notifyListeners);
  }

  Future<void> checkCategoryVersion() async {
    final checkCategoryVersion = _versionRepository.checkCategoryVersion();
    await value.checkCategoryVersion.set(checkCategoryVersion, notifyListeners);
  }

  Future<void> checkFaqVersion() async {
    final checkFaqVersion = _versionRepository.checkFaqVersion();
    await value.checkFaqVersion.set(checkFaqVersion, notifyListeners);
  }

  Future<void> checkForceUpdate(String authJWT) async {
    var checkForceUpdate;
    _packageInfo = await PackageInfo.fromPlatform();
    if(kDebugMode) {
      checkForceUpdate = _versionRepository.checkForceUpdate(3, authJWT);
    }else {
      checkForceUpdate = _versionRepository.checkForceUpdate(int.parse(_packageInfo.buildNumber), authJWT);
    }
    checkForceUpdate.then((value) {
      requireInstall = value.asValue.value.result;
    });
  }

  Future<void> getCategoryLarge() async {
    final getCategoryLarge = _categoryRepository.getCategoryLarge();
    getCategoryLarge.then((value) {
      _dbHelper.delete(TABLE_CATEGORY_LARGE).then((val) {
        _dbHelper.insertCategoryLarge(value.asValue.value.toList());
      });
    });
  }

  Future<void> getCategoryMedium( String largeId) async {
    final getCategoryMedium = _categoryRepository.getCategoryMedium(largeId);
    getCategoryMedium.then((value) {
      _dbHelper.delete(TABLE_CATEGORY_MEDIUM).then((val) {
        _dbHelper.insertCategoryMedium(largeId, value.asValue.value.toList());
      });
    });
  }

  Future<void> getCategoryMediumStar(String authJWT, String largeId) async {
    final getCategoryMediumStar = _categoryRepository.getCategoryMediumStar(authJWT, largeId);
    getCategoryMediumStar.then((value) {
      _dbHelper.updateCategoryMedium(value.asValue.value.toList());
    });
  }

  Future<void> getCategorySmall(String mediumId) async {
    final getCategorySmall = _categoryRepository.getCategorySmall(mediumId);
    await value.getCategorySmall.set(getCategorySmall, notifyListeners);
  }

  Future<void> getSentence(String authJWT, String smallId) async {
    final getSentence = _categoryRepository.getSentence(authJWT, smallId);
    await value.getSentence.set(getSentence, notifyListeners);
  }

  Future<void> getSentenceStages(String authJWT, String sentenceId) async {
    final getSentenceStage = _categoryRepository.getSentenceStages(authJWT, sentenceId);
    await value.getSentenceStages.set(getSentenceStage, notifyListeners);
  }

  Future<void> getPronunciation(String authJWT, String sentenceId, int stageIdx, bool needRight, String voice) async {
    List<dynamic> wrongList = [];
    PronunciationVO rightPronun;
    String fileName = "$sentenceId";
    final getPronunciation = _categoryRepository.getPronunciation(authJWT, sentenceId, stageIdx, needRight, voice);
    await value.getPronunciation.set(getPronunciation, notifyListeners);
    Directory directory = await getApplicationDocumentsDirectory();
    String fileDir = directory.path;
    getPronunciation.then((value) {
      final result = value.asValue.value.result;
      rightPronun = PronunciationVO.fromJson(result['rightPronunciation']);
      _categoryRepository.saveAudioFile(fileDir, rightPronun.downloadUrl, fileName + "-" + rightPronun.pIdx.toString() + "-" + "M.mp3");
      wrongList = result['wrongPronunciationList'] as List;
      wrongList.forEach((element) {
        PronunciationVO pronunciationVO = PronunciationVO.fromJson(element);
        _categoryRepository.saveAudioFile(fileDir, pronunciationVO.downloadUrl, fileName + "-" + pronunciationVO.pIdx.toString() + "-" + "M.mp3");
      });
    });
  }

}