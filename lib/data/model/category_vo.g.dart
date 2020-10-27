// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLargeVO _$CategoryLargeVOFromJson(Map<String, dynamic> json) {
  return CategoryLargeVO(
    json['id'] as String,
    json['title'] as String,
    json['sequence'] as int,
  );
}

Map<String, dynamic> _$CategoryLargeVOToJson(CategoryLargeVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sequence': instance.sequence,
    };

CategoryMediumVO _$CategoryMediumVOFromJson(Map<String, dynamic> json) {
  return CategoryMediumVO(
    json['id'] as String,
    json['title'] as String,
    json['sequence'] as int,
    json['achieveStars'] as int,
    json['totalStars'] as int,
    json['premium'] as bool,
  );
}

Map<String, dynamic> _$CategoryMediumVOToJson(CategoryMediumVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sequence': instance.sequence,
      'achieveStars': instance.archiveStars,
      'totalStars': instance.totalStars,
      'premium': instance.premium,
    };

MediumStarsVO _$MediumStarsVOFromJson(Map<String, dynamic> json) {
  return MediumStarsVO(
    json['id'] as String,
    json['achieveStars'] as int,
    json['totalStars'] as int,
  );
}

Map<String, dynamic> _$MediumStarsVOToJson(MediumStarsVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'achieveStars': instance.achieveStars,
      'totalStars': instance.totalStars,
    };
