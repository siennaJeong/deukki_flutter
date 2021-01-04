// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportVO _$ReportVOFromJson(Map<String, dynamic> json) {
  return ReportVO(
    json['reportIdx'] as int,
    json['listeningScore'] as int,
    json['speakingScore'] as int,
    json['link'] as String,
  );
}

Map<String, dynamic> _$ReportVOToJson(ReportVO instance) => <String, dynamic>{
      'reportIdx': instance.reportIdx,
      'listeningScore': instance.listeningScore,
      'speakingScore': instance.speakingScore,
      'link': instance.link,
    };
