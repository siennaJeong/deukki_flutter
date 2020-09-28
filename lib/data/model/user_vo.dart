
import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO{
  @JsonKey(name: 'socialMethod')
  String socialMethod;

  @JsonKey(name: 'socialId')
  String socialId;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'birthDate')
  String birthDate;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'agreeMarketing')
  bool agreeMarketing;

  @JsonKey(name: 'marketingMethod')
  String marketingMethod;


  UserVO(this.socialMethod, this.socialId, this.email, this.name,
      this.birthDate, this.gender, this.agreeMarketing, this.marketingMethod);

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);
  Map<String, dynamic> toJson() => _$UserVOToJson(this);
}
