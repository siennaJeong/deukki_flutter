
import 'package:json_annotation/json_annotation.dart';

part 'version_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class AppVersionVO {
  @JsonKey(name: 'idx')
  int idx;

  @JsonKey(name: 'appVersion')
  int appVersion;

  @JsonKey(name: 'requireInstall')
  bool requireInstall;

  AppVersionVO(this.idx, this.appVersion, this.requireInstall);

  factory AppVersionVO.fromJson(Map<String, dynamic> json) => _$AppVersionVOFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionVOToJson(this);

  @override
  String toString() {
    return 'AppVersionVO{idx: $idx, appVersion: $appVersion, requireInstall: $requireInstall}';
  }
}

@JsonSerializable(explicitToJson: true)
class CategoryVersionVO {
  @JsonKey(name: 'idx')
  int idx;

  @JsonKey(name: 'largeVersion')
  int largeVersion;

  @JsonKey(name: 'mediumVersion')
  int mediumVersion;

  @JsonKey(name: 'smallVersion')
  int smallVersion;

  CategoryVersionVO(this.idx, this.largeVersion, this.mediumVersion, this.smallVersion);

  factory CategoryVersionVO.fromJson(Map<String, dynamic> json) => _$CategoryVersionVOFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryVersionVOToJson(this);

  @override
  String toString() {
    return 'CategoryVersionVO{idx: $idx, largeVersion: $largeVersion, mediumVersion: $mediumVersion, smallVersion: $smallVersion}';
  }
}

@JsonSerializable(explicitToJson: true)
class FaqVersionVO {
  @JsonKey(name: 'version')
  int version;

  FaqVersionVO(this.version);

  factory FaqVersionVO.fromJson(Map<String, dynamic> json) => _$FaqVersionVOFromJson(json);
  Map<String, dynamic> toJson() => _$FaqVersionVOToJson(this);

  @override
  String toString() {
    return 'FaqVersionVO{version: $version}';
  }
}

@JsonSerializable(explicitToJson: true)
class VersionVOwithDB {
  @JsonKey(name: 'idx')
  int idx;

  @JsonKey(name: 'version_name')
  String versionName;

  @JsonKey(name: 'version')
  int version;

  VersionVOwithDB(this.idx, this.versionName, this.version);

  factory VersionVOwithDB.fromJson(Map<String, dynamic> json) => _$VersionVOwithDBFromJson(json);
  Map<String, dynamic> toJson() => _$VersionVOwithDBToJson(this);

  @override
  String toString() {
    return 'VersionVOwithDB{idx: $idx, versionName: $versionName, version: $version}';
  }
}