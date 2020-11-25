import 'package:json_annotation/json_annotation.dart';

part 'stage_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class StageVO {
  @JsonKey(name: 'stageIdx')
  int stageIdx;

  @JsonKey(name: 'stage')
  int stage;

  @JsonKey(name: 'score')
  int score;

  StageVO(this.stageIdx, this.stage, this.score);

  factory StageVO.fromJson(Map<String, dynamic> json) => _$StageVOFromJson(json);
  Map<String, dynamic> toJson() => _$StageVOToJson(this);

  @override
  String toString() {
    return 'StageVO{stageIdx: $stageIdx, stage: $stage, score: $score}';
  }
}

class PreScoreVO{
  int idx;
  bool isPreScoreExist;

  PreScoreVO(this.idx, this.isPreScoreExist);

  @override
  String toString() {
    return 'PreScoreVO{stageIdx: $idx, isPreScoreExist: $isPreScoreExist}';
  }
}
