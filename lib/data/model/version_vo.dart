
import 'package:json_annotation/json_annotation.dart';

part 'version_vo.g.dart';

@JsonSerializable()
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
}

@JsonSerializable()
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

}

@JsonSerializable()
class FaqVersionVO {
  @JsonKey(name: 'version')
  int version;

  FaqVersionVO(this.version);

  factory FaqVersionVO.fromJson(Map<String, dynamic> json) => _$FaqVersionVOFromJson(json);
  Map<String, dynamic> toJson() => _$FaqVersionVOToJson(this);
}