import 'package:json_annotation/json_annotation.dart';

part 'sentence_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class SentenceVO {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'sequence')
  int sequence;

  @JsonKey(name: 'avgScore')
  double avgScore;

  @JsonKey(name: 'premium')
  int premium;

  @JsonKey(name: 'new')
  int isNew;

  SentenceVO(this.id, this.content, this.sequence, this.avgScore, this.premium, this.isNew);

  factory SentenceVO.fromJson(Map<String, dynamic> json) => _$SentenceVOFromJson(json);
  Map<String, dynamic> toJson() => _$SentenceVOToJson(this);

  @override
  String toString() {
    return 'SentenceVO{id: $id, content: $content, sequence: $sequence, avgScore: $avgScore, premium: $premium, isNew: $isNew}';
  }
}