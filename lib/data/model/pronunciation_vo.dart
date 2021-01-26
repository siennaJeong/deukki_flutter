
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

  @JsonKey(name: 'wrongIndex')
  int wrongIndex;

  PronunciationVO(this.pIdx, this.pronunciation, this.downloadUrl, this.wrongIndex);

  factory PronunciationVO.fromJson(Map<String, dynamic> json) => _$PronunciationVOFromJson(json);
  Map<String, dynamic> toJson() => _$PronunciationVOToJson(this);

  @override
  String toString() {
    return 'PronunciationVO{pIdx: $pIdx, pronunciation: $pronunciation, downloadUrl: $downloadUrl, wrongIdex : $wrongIndex}';
  }
}
