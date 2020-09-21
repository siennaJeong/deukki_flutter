
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/view/values/strings.dart';

abstract class ExceptionMapper {
  static String toErrorMessage(Object error) {
    if (error is ApiException) {
      if (error is ConnectionException) {
        return Strings.connection_error;
      } else if (error is ClientErrorException) {
        return Strings.client_error;
      } else if (error is ServerErrorException) {
        return Strings.server_error;
      } else if (error is EmptyResultException) {
        return Strings.empty_result_error;
      } else {
        return Strings.unknown_error;
      }
    } else {
      return Strings.unknown_error;
    }
  }
}