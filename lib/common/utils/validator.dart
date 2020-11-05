import 'package:deukki/view/values/strings.dart';
import 'package:intl/intl.dart';

class Validator {
  String emailValidation(String value) {
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return null;
    }else {
      return Strings.sign_up_email_invalid;
    }
  }

  String nameValidation(String value) {
    final valid = RegExp(r'^[a-zA-Z0-9 ]+$');
    if(value.length > 1) {
      if(!valid.hasMatch(value)) {
        return null;
      }else {
        return Strings.sign_up_name_invalid;
      }
    }else {
      return Strings.sign_up_name_invalid;
    }
  }

  String yearValidation(String value) {
    int year = int.parse(DateFormat('yyyy').format(DateTime.now()));
    if(int.parse(value) < 1900 || int.parse(value) > year) {
      return Strings.sign_up_year_invalid;
    }else {
      return null;
    }
  }

  String monthValidation(String value) {
    if(int.parse(value) > 12 || int.parse(value) < 1) {
      return Strings.sign_up_year_invalid;
    }else {
      return null;
    }
  }
}