
import 'dart:io';

import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/model/audio_file_path_vo.dart';
import 'package:deukki/data/model/faq_vo.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/model/version_vo.dart';
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
  VersionRepository _versionRepository;
  CategoryRepository _categoryRepository;
  DBHelper _dbHelper;
  AppVersionVO appVersionVO;

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
          dbHelper: DBHelper());

  PackageInfo _packageInfo;
  bool requireInstall = false;
  List<FaqVO> faqs = [];
  List<AudioFilePathVO> _audioFilePath = [];
  List<AudioFilePathVO> filePathList = [];
  Directory directory;

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
    var versionResultApp;
    checkAllVersion.then((value) {
      final versionResult = value.asValue.value.result;
      versionResultApp = versionResult[VersionRepository.APP_VERSION] as Map<String, dynamic>;
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
    await value.checkAllVersion.set(versionResultApp, notifyListeners);
  }

  Future<void> checkAppVersion() async {
    print("check app version");
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

    final dbFile = await _dbHelper.getFilePath(sentenceId);
    if(dbFile != null) {
      filePathList = dbFile.map((items) => AudioFilePathVO.fromJson(items)).toList();
    }
  }

  Future<void> getPronunciation(String authJWT, String sentenceId, int stageIdx, bool needRight, String voice) async {
    List<dynamic> wrongList = [];
    PronunciationVO rightPronun;
    String fileId = "$sentenceId";
    String filePath, dbFilePath;
    final getPronunciation = _categoryRepository.getPronunciation(authJWT, sentenceId, stageIdx, needRight, voice);
    await value.getPronunciation.set(getPronunciation, notifyListeners);

    directory ??= await getApplicationDocumentsDirectory();
    String fileDir = directory.path;

    if(_audioFilePath.length > 0) {
      _audioFilePath.clear();
    }

    getPronunciation.then((val) {
      print("get pronunciation list");
      final result = val.asValue.value.result;
      rightPronun = PronunciationVO.fromJson(result['rightPronunciation']);
      filePath = "$fileId-${rightPronun.pIdx.toString()}-$voice.mp3";
      dbFilePath = "$fileDir/$filePath";
      print("right file path : " + dbFilePath);
      if(filePathList != null && (filePathList.singleWhere((it) => it.path == dbFilePath, orElse: () => null)) != null) {
        setAudioFile(sentenceId, rightPronun.pIdx, dbFilePath);
      }else {
        print("right file path null ? " + filePathList.toString());
        saveAudioFile(fileDir, rightPronun.downloadUrl, filePath);
        setAudioFile(sentenceId, rightPronun.pIdx, dbFilePath);
        _dbHelper.insertAudioFile(sentenceId, rightPronun.pIdx, dbFilePath);
      }

      wrongList = result['wrongPronunciationList'] as List;
      wrongList.forEach((element) {
        PronunciationVO pronunciationVO = PronunciationVO.fromJson(element);
        filePath = "$fileId-${pronunciationVO.pIdx.toString()}-$voice.mp3";
        dbFilePath = "$fileDir/$filePath";
        print("wrong file path : " + dbFilePath);
        if(filePathList != null && (filePathList.singleWhere((it) => it.path == dbFilePath, orElse: () => null)) != null) {
          setAudioFile(sentenceId, pronunciationVO.pIdx, dbFilePath);
        }else {
          print("wrong file path null ? " + filePathList.toString());
          saveAudioFile(fileDir, pronunciationVO.downloadUrl, filePath);
          setAudioFile(sentenceId, pronunciationVO.pIdx, dbFilePath);
          _dbHelper.insertAudioFile(sentenceId, pronunciationVO.pIdx, dbFilePath);
        }
      });
    });
  }

  Future<void> saveAudioFile(String dir, String url, String fileName) async {
    final saveAudioFile = _categoryRepository.saveAudioFile(dir, url, fileName);
    await value.saveAudioFile.set(saveAudioFile, notifyListeners);
  }

  void setAudioFile(String sentenceId, int pIdx, String path) {
    _audioFilePath.add(AudioFilePathVO(sentenceId, pIdx, path));
    notifyListeners();
  }

  List<AudioFilePathVO> get audioFilePath => _audioFilePath;

  Future<void> recordUpload(String authJWT, File file, int stage, int round, String sentenceId) async {
    final recordUpload = _categoryRepository.recordUploadLink(authJWT, file, stage, round, sentenceId);
    await value.recordUpload.set(recordUpload, notifyListeners);
  }

  Future<void> getFaq() async {
    final faqList = await _dbHelper.getFaqs();
    faqs = faqList;
  }
}