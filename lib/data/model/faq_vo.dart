
import 'package:json_annotation/json_annotation.dart';

part 'faq_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class FaqVO {
  @JsonKey(name: 'idx')
  int idx;

  @JsonKey(name: 'question')
  String question;

  @JsonKey(name: 'answer')
  String answer;

  @JsonKey(name: 'sequence')
  int sequence;

  FaqVO(this.idx, this.question, this.answer, this.sequence);

  factory FaqVO.fromJson(Map<String, dynamic> json) => _$FaqVOFromJson(json);
  Map<String, dynamic> toJson() => _$FaqVOToJson(this);

  @override
  String toString() {
    return 'FaqVO{idx: $idx, question: $question, answer: $answer, sequence: $sequence}';
  }
}