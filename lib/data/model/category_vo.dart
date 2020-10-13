import 'package:json_annotation/json_annotation.dart';

part 'category_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryVO {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  CategoryVO(this.id, this.title);
}

@JsonSerializable(explicitToJson: true)
class CategoryLargeVO extends CategoryVO {
  @JsonKey(name: 'sequence')
  int sequence;

  CategoryLargeVO(String id, String title, this.sequence) : super(id, title);

  factory CategoryLargeVO.fromJson(Map<String, dynamic> json) => _$CategoryLargeVOFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryLargeVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryMediumVO extends CategoryVO {
  @JsonKey(name: 'sequence')
  int sequence;

  @JsonKey(name: 'premium')
  bool premium;

  CategoryMediumVO(String id, String title, this.sequence, this.premium) : super(id, title);

  factory CategoryMediumVO.fromJson(Map<String, dynamic> json) => _$CategoryMediumVOFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryMediumVOToJson(this);
}