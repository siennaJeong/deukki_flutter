// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentenceVO _$SentenceVOFromJson(Map<String, dynamic> json) {
  return SentenceVO(
    json['id'] as String,
    json['content'] as String,
    json['sequence'] as int,
    (json['avgScore'] as num)?.toDouble(),
    json['premium'] as int,
    json['new'] as int,
  );
}

Map<String, dynamic> _$SentenceVOToJson(SentenceVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sequence': instance.sequence,
      'avgScore': instance.avgScore,
      'premium': instance.premium,
      'new': instance.isNew,
    };
