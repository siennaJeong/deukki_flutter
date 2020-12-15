import 'dart:io';

import 'package:async/async.dart';
import 'package:deukki/data/model/common_result_vo.dart';

abstract class PaymentRepository {
  Future<Result<String>> paymentPreRequest(String authJWT, String type, int amount, String currency, bool iap, String iapProvider, int productionIdx);
  Future<Result<int>> couponRegistration(String authJWT, String code);
  Future<Result<CommonResultVO>> paymentValidation(String authJWT, String platform, String receipt, String paymentId);
}