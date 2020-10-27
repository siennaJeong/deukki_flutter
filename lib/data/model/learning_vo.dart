
import 'package:json_annotation/json_annotation.dart';

part 'learning_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class LearningVO {
  @JsonKey(name: 'time')
  int time;

  @JsonKey(name: 'countCorrectAnswer')
  int countCorrectAnswer;

  @JsonKey(name: 'stageIdx')
  int stageIdx;

  @JsonKey(name: 'history')
  List<HistoryVO> history;

  LearningVO(this.time, this.countCorrectAnswer, this.stageIdx, this.history);

  factory LearningVO.fromJson(Map<String, dynamic> json) => _$LearningVOFromJson(json);
  Map<String, dynamic> toJson() => _$LearningVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HistoryVO {
  @JsonKey(name: 'level')
  int level;

  @JsonKey(name: 'round')
  int round;

  @JsonKey(name: 'correct')
  bool correct;

  @JsonKey(name: 'soundRepeat')
  int soundRepeat;

  @JsonKey(name: 'playPIdx')
  int playPIdx;

  @JsonKey(name: 'selectPIdx')
  int selectPIdx;

  HistoryVO(this.level, this.round, this.correct, this.soundRepeat, this.playPIdx, this.selectPIdx);
}