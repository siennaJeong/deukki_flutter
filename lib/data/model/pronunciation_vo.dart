
import 'package:json_annotation/json_annotation.dart';

part 'pronunciation_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class PronunciationVO {
  @JsonKey(name: 'pIdx')
  int pIdx;

  @JsonKey(name: 'pronunciation')
  String pronunciation;

  @JsonKey(name: 'downloadUrl')
  String downloadUrl;

  PronunciationVO(this.pIdx, this.pronunciation, this.downloadUrl);

  factory PronunciationVO.fromJson(Map<String, dynamic> json) => _$PronunciationVOFromJson(json);
  Map<String, dynamic> toJson() => _$PronunciationVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WrongPListVO {
  @JsonKey(name: 'wrongPronunciationList')
  PronunciationVO pronunciationVO;

  WrongPListVO(this.pronunciationVO);

  factory WrongPListVO.fromJson(Map<String, dynamic> json) => _$WrongPListVOFromJson(json);
  Map<String, dynamic> toJson() => _$WrongPListVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RightPVO {
  @JsonKey(name: 'rightPronunciation')
  PronunciationVO pronunciationVO;

  RightPVO(this.pronunciationVO);

  factory RightPVO.fromJson(Map<String, dynamic> json) => _$RightPVOFromJson(json);
  Map<String, dynamic> toJson() => _$RightPVOToJson(this);
}