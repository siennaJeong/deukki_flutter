// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_result_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonResultVO _$CommonResultVOFromJson(Map<String, dynamic> json) {
  return CommonResultVO(
    json['status'] as int,
    json['message'] as String,
    json['result'],
  );
}

Map<String, dynamic> _$CommonResultVOToJson(CommonResultVO instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
