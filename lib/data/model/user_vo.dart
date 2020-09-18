
import 'package:deukki/common/network/response_mappers.dart';

class UserVO {
  UserVO({
    this.accessToken,
    this.email,
    this.birthDate,
    this.gender,
    this.name,
    this.marketingAgree,
  });

  final String accessToken;
  final String email;
  final String name;
  final String birthDate;
  final int gender;
  final bool marketingAgree;

  factory UserVO.fromJson(Map<String, dynamic> json) => UserVO (
    accessToken: json['access_token'],
    email: json['email'],
    name: json['name'],
    birthDate: json['birth_date'],
    gender: json['gender'],
    marketingAgree: json['marketing_agree']
  );

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'email': email,
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'agreeMarketing': marketingAgree,
    };
  }
}

class UserVoList extends ListMappable {
  List<UserVO> userList;

  @override
  ResponseMappable fromJsonList(List json) {
    userList = json.map((e) => UserVO.fromJson(e)).toList();
    return this;
  }
}