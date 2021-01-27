
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/view/values/strings.dart';

abstract class ExceptionMapper {
  static String toErrorMessage(Object error) {
    if (error is ApiException) {
      if (error is ConnectionException) {
        print("http connection exception");
        return Strings.connection_error;
      } else if (error is ClientErrorException) {
        print("client error exception");
        return Strings.client_error;
      } else if (error is ServerErrorException) {
        print("server error exception");
        return Strings.server_error;
      } else if (error is EmptyResultException) {
        print("empty result exception");
        return Strings.empty_result_error;
      } else {
        print("unknown error exception");
        return Strings.unknown_error;
      }
    } else {
      print("unknown error exception");
      return Strings.unknown_error;
    }
  }
}