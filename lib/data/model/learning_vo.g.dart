// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningVO _$LearningVOFromJson(Map<String, dynamic> json) {
  return LearningVO(
    json['time'] as String,
    json['countCorrectAnswer'] as String,
    json['stageIdx'] as String,
    (json['history'] as List)?.map((e) => e as Map<String, dynamic>)?.toList(),
  );
}

Map<String, dynamic> _$LearningVOToJson(LearningVO instance) =>
    <String, dynamic>{
      'time': instance.time,
      'countCorrectAnswer': instance.countCorrectAnswer,
      'stageIdx': instance.stageIdx,
      'history': instance.history,
    };

HistoryVO _$HistoryVOFromJson(Map<String, dynamic> json) {
  return HistoryVO(
    json['level'] as String,
    json['round'] as String,
    json['correct'] as String,
    json['soundRepeat'] as String,
    json['playPIdx'] as String,
    json['selectPIdx'] as String,
  );
}

Map<String, dynamic> _$HistoryVOToJson(HistoryVO instance) => <String, dynamic>{
      'level': instance.level,
      'round': instance.round,
      'correct': instance.correct,
      'soundRepeat': instance.soundRepeat,
      'playPIdx': instance.playPIdx,
      'selectPIdx': instance.selectPIdx,
    };
