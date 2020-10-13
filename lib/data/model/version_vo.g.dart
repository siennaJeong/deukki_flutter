// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionVO _$AppVersionVOFromJson(Map<String, dynamic> json) {
  return AppVersionVO(
    json['idx'] as int,
    json['appVersion'] as int,
    json['requireInstall'] as bool,
  );
}

Map<String, dynamic> _$AppVersionVOToJson(AppVersionVO instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'appVersion': instance.appVersion,
      'requireInstall': instance.requireInstall,
    };

CategoryVersionVO _$CategoryVersionVOFromJson(Map<String, dynamic> json) {
  return CategoryVersionVO(
    json['idx'] as int,
    json['largeVersion'] as int,
    json['mediumVersion'] as int,
    json['smallVersion'] as int,
  );
}

Map<String, dynamic> _$CategoryVersionVOToJson(CategoryVersionVO instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'largeVersion': instance.largeVersion,
      'mediumVersion': instance.mediumVersion,
      'smallVersion': instance.smallVersion,
    };

FaqVersionVO _$FaqVersionVOFromJson(Map<String, dynamic> json) {
  return FaqVersionVO(
    json['version'] as int,
  );
}

Map<String, dynamic> _$FaqVersionVOToJson(FaqVersionVO instance) =>
    <String, dynamic>{
      'version': instance.version,
    };

VersionVOwithDB _$VersionVOwithDBFromJson(Map<String, dynamic> json) {
  return VersionVOwithDB(
    json['idx'] as int,
    json['version_name'] as String,
    json['version'] as int,
  );
}

Map<String, dynamic> _$VersionVOwithDBToJson(VersionVOwithDB instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'version_name': instance.versionName,
      'version': instance.version,
    };
