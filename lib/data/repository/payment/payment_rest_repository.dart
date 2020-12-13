
import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/common/network/exception_mapper.dart';
import 'package:deukki/common/network/http_client.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/repository/payment/payment_repository.dart';

class PaymentRestRepository implements PaymentRepository {
  final HttpClient _httpClient = HttpClient();

  Map<String, dynamic> paymentToJson(String type, int amount, String currency, bool iap, String iapProvider, int productionIdx) => <String, dynamic>{
    'type': type,
    'amount': "$amount",
    'currency': currency,
    'iap': "$iap",
    'iapProvider': iapProvider,
    'productionIdx': "$productionIdx",
  };

  @override
  Future<Result<String>> paymentPreRequest(String authJWT, String type, int amount, String currency, bool iap, String iapProvider, int productionIdx) async {
    final paymentPreRequest = await _httpClient.postRequest(HttpUrls.PRE_PAYMENT, HttpUrls.postHeaders(authJWT), paymentToJson(type, amount, currency, iap, iapProvider, productionIdx));
    if(paymentPreRequest.isValue) {
      final result = paymentPreRequest.asValue.value['result'];
      return Result.value(result['paymentId']);
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

}