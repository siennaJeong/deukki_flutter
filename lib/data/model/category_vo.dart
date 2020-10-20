import 'package:json_annotation/json_annotation.dart';

part 'category_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryLargeVO{
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'sequence')
  int sequence;

  CategoryLargeVO(this.id, this.title, this.sequence);

  factory CategoryLargeVO.fromJson(Map<String, dynamic> json) => _$CategoryLargeVOFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryLargeVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryMediumVO extends CategoryLargeVO {
  @JsonKey(name: 'achiveStars')
  int archiveStars;

  @JsonKey(name: 'totalStars')
  int totalStars;

  @JsonKey(name: 'premium')
  bool premium;

  CategoryMediumVO(String id, String title, int sequence , this.archiveStars, this.totalStars, this.premium) : super(id, title, sequence);

  factory CategoryMediumVO.fromJson(Map<String, dynamic> json) => _$CategoryMediumVOFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryMediumVOToJson(this);
}