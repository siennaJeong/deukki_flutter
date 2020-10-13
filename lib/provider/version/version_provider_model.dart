
import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/repository/version/version_repository.dart';
import 'package:deukki/data/repository/version/version_rest_repository.dart';
import 'package:deukki/provider/provider_model.dart';
import 'package:deukki/provider/version/version_provider_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

class VersionProviderModel extends ProviderModel<VersionProviderState> {
  VersionProviderModel({@required VersionRepository versionRepository, @required DBHelper dbHelper})
      : assert(versionRepository != null),
        _versionRepository = versionRepository,
        _dbHelper = dbHelper,
        super(VersionProviderState());

  factory VersionProviderModel.build() => VersionProviderModel(versionRepository: VersionRestRepository(), dbHelper: DBHelper());
  final VersionRepository _versionRepository;
  final DBHelper _dbHelper;
  PackageInfo _packageInfo;

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
        return;
      }else {
        //  version 낮을때 카테고리 업데이트
        for(int i = 1 ; i < dbVersion.length ; i++) {
          if(dbVersion.elementAt(i).values.elementAt(1) == VersionRepository.CATEGORY_LARGE_VERSION &&
          dbVersion.elementAt(i).values.elementAt(2) < versionResultCategory[VersionRepository.CATEGORY_LARGE_VERSION]) {
            print("large category update");
          }
          if(dbVersion.elementAt(i).values.elementAt(1) == VersionRepository.CATEGORY_MEDIUM_VERSION &&
          dbVersion.elementAt(i).values.elementAt(2) < versionResultCategory[VersionRepository.CATEGORY_MEDIUM_VERSION]) {
            print("medium category update");
          }
          if(dbVersion.elementAt(i).values.elementAt(1) == VersionRepository.FAQ_VERSION &&
          dbVersion.elementAt(i).values.elementAt(2) < versionResultFaq[VersionRepository.VERSION]) {
            print("faq update");
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
    _packageInfo = await PackageInfo.fromPlatform();
    //final checkForceUpdate = _versionRepository.checkForceUpdate(int.parse(_packageInfo.buildNumber), authJWT);
    final checkForceUpdate = _versionRepository.checkForceUpdate(3, authJWT);
    await value.checkForceUpdate.set(checkForceUpdate, notifyListeners);
  }
}