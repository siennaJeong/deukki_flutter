import 'package:intl/intl.dart';

class Validator {
  bool emailValidation(String value) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
  }

  bool nameValidation(String value) {
    return value.length > 1 ? true : false;
  }

  bool yearValidation(int value) {
    int year = int.parse(DateFormat('yyyy').format(DateTime.now()));
    if(value < 1900 || value > year) {
      return false;
    }else {
      return true;
    }
  }

  bool monthValidation(int value) {
    if(value > 12 || value < 1) {
      return false;
    }else {
      return true;
    }
  }
}