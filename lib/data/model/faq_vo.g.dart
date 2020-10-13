// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqVO _$FaqVOFromJson(Map<String, dynamic> json) {
  return FaqVO(
    json['idx'] as int,
    json['question'] as String,
    json['answer'] as String,
    json['sequence'] as int,
  );
}

Map<String, dynamic> _$FaqVOToJson(FaqVO instance) => <String, dynamic>{
      'idx': instance.idx,
      'question': instance.question,
      'answer': instance.answer,
      'sequence': instance.sequence,
    };
