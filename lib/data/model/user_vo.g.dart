// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) {
  return UserVO(
    json['idx'] as int,
    json['email'] as String,
    json['name'] as String,
    json['birthDate'] as String,
    json['gender'] as String,
    json['enable'] as bool,
    json['premium'] as bool,
  );
}

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'idx': instance.idx,
      'email': instance.email,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'enable': instance.enable,
      'premium': instance.premium,
    };
