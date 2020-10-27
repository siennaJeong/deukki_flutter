
part of 'bookmark_vo.dart';

BookmarkVO _$BookmarkVOFromJson(Map<String, dynamic> json) {
  return BookmarkVO(
    json['bookmarkIdx'] as int,
    json['content'] as String,
    json['stage'] as int,
    json['score'] as int,
    json['sentenceId'] as String,
    json['stageIdx'] as int
  );
}

Map<String, dynamic> _$BookmarkVOToJson(BookmarkVO instance) =>
    <String, dynamic>{
      'bookmarkIdx': instance.bookmarkIdx,
      'content': instance.content,
      'stage': instance.stage,
      'score': instance.score,
      'sentenceId': instance.sentenceId,
      'stageIdx': instance.stageIdx
    };