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

  @override
  String toString() {
    return 'CategoryLargeVO{id: $id, title: $title, sequence: $sequence}';
  }
}

@JsonSerializable(explicitToJson: true)
class CategoryMediumVO extends CategoryLargeVO {
  @JsonKey(name: 'achieveStars')
  int archiveStars;

  @JsonKey(name: 'totalStars')
  int totalStars;

  @JsonKey(name: 'premium')
  bool premium;

  CategoryMediumVO(String id, String title, int sequence , this.archiveStars, this.totalStars, this.premium) : super(id, title, sequence);

  factory CategoryMediumVO.fromJson(Map<String, dynamic> json) => _$CategoryMediumVOFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryMediumVOToJson(this);

  @override
  String toString() {
    return 'CategoryMediumVO{archiveStars: $archiveStars, totalStars: $totalStars, premium: $premium}';
  }
}

@JsonSerializable(explicitToJson: true)
class MediumStarsVO {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'achieveStars')
  int achieveStars;

  @JsonKey(name: 'totalStars')
  int totalStars;

  MediumStarsVO(this.id, this.achieveStars, this.totalStars);

  factory MediumStarsVO.fromJson(Map<String, dynamic> json) => _$MediumStarsVOFromJson(json);
  Map<String, dynamic> toJson() => _$MediumStarsVOToJson(this);

  @override
  String toString() {
    return 'MediumStarsVO{id: $id, achieveStars: $achieveStars, totalStars: $totalStars}';
  }
}