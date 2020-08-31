import 'package:meta/meta.dart';

class UserVO {
  UserVO({
    this.uid,
    this.email,
    this.birthDate,
    this.gender,
    this.name
  });

  final String uid;
  final String email;
  final String name;
  final String birthDate;
  final int gender;

}