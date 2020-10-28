
import 'dart:convert';

import 'package:deukki/view/values/app_images.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'learning_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class LearningVO {
  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'countCorrectAnswer')
  String countCorrectAnswer;

  @JsonKey(name: 'stageIdx')
  String stageIdx;

  @JsonKey(name: 'history')
  List<Map> history;

  LearningVO(this.time, this.countCorrectAnswer, this.stageIdx, this.history);

  factory LearningVO.fromJson(Map<String, dynamic> json) => _$LearningVOFromJson(json);
  Map<String, dynamic> toJson() => _$LearningVOToJson(this);

  Map<String, String> bodyJson() =>
      <String, String> {
        'time': time,
        'countCorrectAnswer': countCorrectAnswer,
        'stageIdx': stageIdx,
        'history': jsonEncode(history)
      };

  @override
  String toString() {
    return 'LearningVO{time: $time, countCorrectAnswer: $countCorrectAnswer, stageIdx: $stageIdx, history: $history}';
  }
}

@JsonSerializable(explicitToJson: true)
class HistoryVO {
  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'round')
  String round;

  @JsonKey(name: 'correct')
  String correct;

  @JsonKey(name: 'soundRepeat')
  String soundRepeat;

  @JsonKey(name: 'playPIdx')
  String playPIdx;

  @JsonKey(name: 'selectPIdx')
  String selectPIdx;

  HistoryVO(this.level, this.round, this.correct, this.soundRepeat, this.playPIdx, this.selectPIdx);

  factory HistoryVO.fromJson(Map<String, dynamic> json) => _$HistoryVOFromJson(json);
  Map<String, String> toJson() => _$HistoryVOToJson(this);

  Map<String, String> bodyJson() =>
      <String, String> {
        'level': this.level,
        'round': this.round,
        'correct': this.correct,
        'soundRepeat': this.soundRepeat,
        'playPIdx': this.playPIdx,
        'selectPIdx':this.selectPIdx
      };

  @override
  String toString() {
    return 'HistoryVO{level: $level, round: $round, correct: $correct, soundRepeat: $soundRepeat, playPIdx: $playPIdx, selectPIdx: $selectPIdx}';
  }
}