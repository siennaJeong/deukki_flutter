
import 'package:deukki/data/repository/payment/payment_repository.dart';
import 'package:deukki/data/repository/payment/payment_rest_repository.dart';
import 'package:deukki/provider/payment/payment_provider_state.dart';
import 'package:deukki/provider/provider_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String TYPE_SUBSCRIPTION = "Subscription";
const String TYPE_OFFLINE = "Offline";
const String CURRENCY_KRW = "KRW";
const String CURRENCY_USD = "USD";

class PaymentProviderModel extends ProviderModel<PaymentProviderState> {
  PaymentProviderModel({@required PaymentRepository paymentRepository})
      : assert(paymentRepository != null),
        _paymentRepository = paymentRepository,
        super(PaymentProviderState());

  factory PaymentProviderModel.build() => PaymentProviderModel(paymentRepository: PaymentRestRepository());
  final PaymentRepository _paymentRepository;

  Future<void> paymentPreRequest(String authJWT, String type, int amount, String currency, bool iap, String iapProvider, int productionIdx) async {
    final paymentPreRequest = _paymentRepository.paymentPreRequest(authJWT, type, amount, currency, iap, iapProvider, productionIdx);
    await value.paymentPreRequest.set(paymentPreRequest, notifyListeners);
  }

}