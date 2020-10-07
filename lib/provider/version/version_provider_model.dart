
import 'package:deukki/data/repository/version/version_repository.dart';
import 'package:deukki/data/repository/version/version_rest_repository.dart';
import 'package:deukki/provider/provider_model.dart';
import 'package:deukki/provider/version/version_provider_state.dart';
import 'package:flutter/cupertino.dart';

class VersionProviderModel extends ProviderModel<VersionProviderState> {
  VersionProviderModel({@required VersionRepository versionRepository})
      : assert(versionRepository != null),
        _versionRepository = versionRepository,
        super(VersionProviderState());

  factory VersionProviderModel.build() => VersionProviderModel(versionRepository: VersionRestRepository());
  final VersionRepository _versionRepository;

  Future<void> checkAllVersion() async {
    final checkAllVersion = _versionRepository.checkAllVersion();
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
    final checkForceUpdate = _versionRepository.checkForceUpdate(authJWT);
    await value.checkForceUpdate.set(checkForceUpdate, notifyListeners);
  }
}