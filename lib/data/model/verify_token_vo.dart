
import 'package:json_annotation/json_annotation.dart';

part 'verify_token_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class VerifyTokenVO {
  @JsonKey(name: 'idx')
  int idx;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'premium')
  bool premium;

  VerifyTokenVO(this.idx, this.email, this.name, this.premium);

  factory VerifyTokenVO.fromJson(Map<String, dynamic> json) => _$VerifyTokenVOFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyTokenVOToJson(this);

  @override
  String toString() {
    return 'VerifyTokenVO{idx: $idx, email: $email, name: $name, premium: $premium}';
  }
}