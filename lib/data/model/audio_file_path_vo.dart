
import 'package:json_annotation/json_annotation.dart';

part 'audio_file_path_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class AudioFilePathVO {
  @JsonKey(name: 'sentence_id')
  String sentenceId;

  @JsonKey(name: 'p_idx')
  int stageIdx;

  @JsonKey(name: 'path')
  String path;

  AudioFilePathVO(this.sentenceId, this.stageIdx, this.path);

  factory AudioFilePathVO.fromJson(Map<String, dynamic> json) => _$AudioFilePathVOFromJson(json);
  Map<String, dynamic> toJson() => _$AudioFilePathVOToJson(this);

  @override
  String toString() {
    return 'AudioFilePathVO{sentenceId: $sentenceId, stageIdx: $stageIdx, path: $path}';
  }
}