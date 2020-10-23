
part of 'audio_file_path_vo.dart';

AudioFilePathVO _$AudioFilePathVOFromJson(Map<String, dynamic> json) {
  return AudioFilePathVO(
    json['sentence_id'] as String,
    json['stage_idx'] as int,
    json['path'] as String,
  );
}

Map<String, dynamic> _$AudioFilePathToJson(AudioFilePathVO instance) =>
    <String, dynamic>{
      'sentence_id': instance.sentenceId,
      'stage_idx': instance.stageIdx,
      'path': instance.path,
    };