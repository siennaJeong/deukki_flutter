import 'dart:async';

import 'package:deukki/provider/payment/payment_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumPopup extends BaseWidget {
  @override
  _PremiumPopupState createState() => _PremiumPopupState();
}

class _PremiumPopupState extends State<PremiumPopup> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  PaymentProviderModel _paymentProviderModel;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
