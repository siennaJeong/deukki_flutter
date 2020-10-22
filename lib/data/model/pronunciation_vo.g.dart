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
