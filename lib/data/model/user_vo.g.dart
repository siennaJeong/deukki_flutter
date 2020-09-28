// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) {
  return UserVO(
    json['socialMethod'] as String,
    json['socialId'] as String,
    json['email'] as String,
    json['name'] as String,
    json['birthDate'] as String,
    json['gender'] as String,
    json['agreeMarketing'] as bool,
    json['marketingMethod'] as String,
  );
}

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'socialMethod': instance.socialMethod,
      'socialId': instance.socialId,
      'email': instance.email,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'agreeMarketing': instance.agreeMarketing,
      'marketingMethod': instance.marketingMethod,
    };
