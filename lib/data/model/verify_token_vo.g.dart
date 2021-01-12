// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_token_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTokenVO _$VerifyTokenVOFromJson(Map<String, dynamic> json) {
  return VerifyTokenVO(
    json['idx'] as int,
    json['email'] as String,
    json['name'] as String,
    json['premium'] as bool,
  );
}

Map<String, dynamic> _$VerifyTokenVOToJson(VerifyTokenVO instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'email': instance.email,
      'name': instance.name,
      'premium': instance.premium,
    };
