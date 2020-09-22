// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_result_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonResultVO _$CommonResultVOFromJson(Map<String, dynamic> json) {
  return CommonResultVO(
    json['responseCode'] as int,
    json['result'] as bool,
    json['resultMessage'] as String,
  );
}

Map<String, dynamic> _$CommonResultVOToJson(CommonResultVO instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'result': instance.result,
      'resultMessage': instance.resultMessage,
    };
