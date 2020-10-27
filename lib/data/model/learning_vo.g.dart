
part of 'learning_vo.dart';

LearningVO _$LearningVOFromJson(Map<String, dynamic> json) {
  return LearningVO(
    json['time'] as int,
    json['countCorrectAnswer'] as int,
    json['stageIdx'] as int,
    json['history'] as List<HistoryVO>
  );
}

Map<String, dynamic> _$LearningVOToJson(LearningVO instance) =>
    <String, dynamic>{
      'time': instance.time,
      'countCorrectAnswer': instance.countCorrectAnswer,
      'stageIdx': instance.stageIdx,
      'history': instance.history
    };
