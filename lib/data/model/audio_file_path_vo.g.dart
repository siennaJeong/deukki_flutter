// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file_path_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioFilePathVO _$AudioFilePathVOFromJson(Map<String, dynamic> json) {
  return AudioFilePathVO(
    json['sentence_id'] as String,
    json['p_idx'] as int,
    json['path'] as String,
  );
}

Map<String, dynamic> _$AudioFilePathVOToJson(AudioFilePathVO instance) =>
    <String, dynamic>{
      'sentence_id': instance.sentenceId,
      'p_idx': instance.stageIdx,
      'path': instance.path,
    };
