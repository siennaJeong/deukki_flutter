
import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/search.dart';

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

  BookmarkVO(this.bookmarkIdx, this.content, this.stage, this.score);

  factory BookmarkVO.fromJson(Map<String, dynamic> json) => _$BookmarkVOFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkVOToJson(this);
}