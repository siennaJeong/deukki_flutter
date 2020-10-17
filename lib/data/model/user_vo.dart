
import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO{
  @JsonKey(name: 'idx')
  int idx;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'birthDate')
  String birthDate;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'defaultVoice')
  String defaultVoice;

  @JsonKey(name: 'enable')
  bool enable;

  @JsonKey(name: 'premium')
  bool premium;


  UserVO(this.idx, this.email, this.name, this.birthDate, this.gender, this.defaultVoice, this.enable, this.premium);

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);
}
