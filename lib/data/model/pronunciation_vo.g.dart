// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pronunciation_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PronunciationVO _$PronunciationVOFromJson(Map<String, dynamic> json) {
  return PronunciationVO(
    json['pIdx'] as int,
    json['pronunciation'] as String,
    json['downloadUrl'] as String,
  );
}

Map<String, dynamic> _$PronunciationVOToJson(PronunciationVO instance) =>
    <String, dynamic>{
      'pIdx': instance.pIdx,
      'pronunciation': instance.pronunciation,
      'downloadUrl': instance.downloadUrl,
    };

WrongPListVO _$WrongPListVOFromJson(Map<String, dynamic> json) {
  return WrongPListVO(
    json['wrongPronunciationList'] == null
        ? null
        : PronunciationVO.fromJson(
            json['wrongPronunciationList'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WrongPListVOToJson(WrongPListVO instance) =>
    <String, dynamic>{
      'wrongPronunciationList': instance.pronunciationVO?.toJson(),
    };

RightPVO _$RightPVOFromJson(Map<String, dynamic> json) {
  return RightPVO(
    json['rightPronunciation'] == null
        ? null
        : PronunciationVO.fromJson(
            json['rightPronunciation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RightPVOToJson(RightPVO instance) => <String, dynamic>{
      'rightPronunciation': instance.pronunciationVO?.toJson(),
    };
