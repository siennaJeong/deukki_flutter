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
    json['defaultVoice'] as String,
    json['enable'] as int,
    json['premium'] as int,
  );
}

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'idx': instance.idx,
      'email': instance.email,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'defaultVoice': instance.defaultVoice,
      'enable': instance.enable,
      'premium': instance.premium,
    };

UserVOForHttp _$UserVOForHttpFromJson(Map<String, dynamic> json) {
  return UserVOForHttp(
    json['idx'] as int,
    json['email'] as String,
    json['name'] as String,
    json['birthDate'] as String,
    json['gender'] as String,
    json['defaultVoice'] as String,
    json['enable'] as int,
    json['premium'] as int,
    json['loginMethod'] as int,
    json['noticeAgree'] as int,
    json['premiumType'] as int,
    json['premiumEndAt'] as String,
  );
}

Map<String, dynamic> _$UserVOForHttpToJson(UserVOForHttp instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'email': instance.email,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'defaultVoice': instance.defaultVoice,
      'enable': instance.enable,
      'premium': instance.premium,
      'loginMethod': instance.loginMethod,
      'noticeAgree': instance.noticeAgree,
      'premiumType': instance.premiumType,
      'premiumEndAt': instance.premiumEndAt,
    };
