
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

  @override
  String toString() {
    return 'UserVO{idx: $idx, email: $email, name: $name, birthDate: $birthDate, gender: $gender, defaultVoice: $defaultVoice, enable: $enable, premium: $premium}';
  }
}

@JsonSerializable(explicitToJson: true)
class UserVOForHttp extends UserVO {
  @JsonKey(name: 'loginMethod')
  int loginMethod;

  @JsonKey(name: 'noticeAgree')
  bool noticeAgree;

  @JsonKey(name: 'premiumType')
  int premiumType;

  @JsonKey(name: 'premiumEndAt')
  String premiumEndAt;

  UserVOForHttp(
      int idx,
      String email,
      String name,
      String birthDate,
      String gender,
      String defaultVoice,
      bool enable,
      bool premium,
      this.loginMethod,
      this.noticeAgree,
      this.premiumType,
      this.premiumEndAt)
      : super(idx, email, name, birthDate, gender, defaultVoice, enable, premium);


}
