
import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/search.dart';
import 'package:path/path.dart';

part 'bookmark_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class BookmarkVO {
  @JsonKey(name: 'bookmarkIdx')
  int bookmarkIdx;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'stage')
  int stage;

  @JsonKey(name: 'score')
  int score;

  @JsonKey(name: 'sentenceId')
  String sentenceId;

  @JsonKey(name: 'stageIdx')
  int stageIdx;

  BookmarkVO(this.bookmarkIdx, this.content, this.stage, this.score, this.sentenceId, this.stageIdx);

  factory BookmarkVO.fromJson(Map<String, dynamic> json) => _$BookmarkVOFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkVOToJson(this);
}