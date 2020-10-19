// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageVO _$StageVOFromJson(Map<String, dynamic> json) {
  return StageVO(
    json['stageIdx'] as int,
    json['stage'] as int,
    json['score'] as int,
  );
}

Map<String, dynamic> _$StageVOToJson(StageVO instance) => <String, dynamic>{
      'stageIdx': instance.stageIdx,
      'stage': instance.stage,
      'score': instance.score,
    };
