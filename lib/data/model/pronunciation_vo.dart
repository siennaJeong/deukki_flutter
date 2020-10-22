
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
