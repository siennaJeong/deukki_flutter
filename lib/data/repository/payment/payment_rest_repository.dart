
import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/common/network/exception_mapper.dart';
import 'package:deukki/common/network/http_client.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/repository/payment/payment_repository.dart';

class PaymentRestRepository implements PaymentRepository {
  final HttpClient _httpClient = HttpClient();

  Map<String, dynamic> paymentToJson(String type, int amount, String currency, bool iap, String iapProvider, bool trial, int trialDays, int productionIdx) => <String, dynamic>{
    'type': type,
    'amount': "$amount",
    'currency': currency,
    'iap': "$iap",
    'iapProvider': iapProvider,
    'productionIdx': "$productionIdx",
  };

  Map<String, dynamic> validateToJson(String platform, String receipt, String paymentId) => <String, dynamic>{
    'platform': platform,
    'receipt': receipt,
    'paymentId': paymentId
  };

  @override
  Future<Result<String>> paymentPreRequest(String authJWT, String type, int amount, String currency, bool iap, String iapProvider, bool trial, int trialDays, int productionIdx) async {
    final paymentPreRequest = await _httpClient.postRequest(HttpUrls.PRE_PAYMENT, HttpUrls.postHeaders(authJWT), paymentToJson(type, amount, currency, iap, iapProvider, trial, trialDays, productionIdx));
    if(paymentPreRequest.isValue) {
      final result = paymentPreRequest.asValue.value['result'];
      return Result.value(result['paymentId']);
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<int>> couponRegistration(String authJWT, String code) async {
    final couponRegistration = await _httpClient.couponRequest("${HttpUrls.COUPON}/$code", HttpUrls.headers(authJWT), null);
    if(couponRegistration.isValue) {
      //final result = couponRegistration.asValue.value['status'];
      return Result.value(couponRegistration.asValue.value);
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> paymentValidation(String authJWT, String platform, String receipt, String paymentId) async {
    final paymentValidation = await _httpClient.paymentRequest(HttpUrls.PAYMENT_VALIDATION, HttpUrls.postHeaders(authJWT), validateToJson(platform, receipt, paymentId));
    if(paymentValidation.isValue) {
      print("payment valid value : ${paymentValidation.asValue.value}");
      return Result.value(CommonResultVO.fromJson(paymentValidation.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

}