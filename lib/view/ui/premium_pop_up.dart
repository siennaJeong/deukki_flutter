import 'dart:async';
import 'dart:io';

import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/payment/payment_provider_model.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/store_kit_wrappers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PremiumPopup extends BaseWidget {
  @override
  _PremiumPopupState createState() => _PremiumPopupState();
}

class _PremiumPopupState extends State<PremiumPopup> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  UserProviderModel _userProviderModel;
  AuthServiceAdapter _authServiceAdapter;
  PaymentProviderModel _paymentProviderModel;

  Future<void> paymentPreRequestInit;
  var initPaymentPreRequest;

  List<ProductDetails> _products = [];

  List<String> _productIds = [];

  double deviceWidth, deviceHeight;
  String _paymentId;
  bool _isAvailable = false;
  bool _autoConsume = true;
  bool _isPaying = false;

  @override
  void initState() {
    _authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    _userProviderModel = Provider.of<UserProviderModel>(context, listen: false);

    _addProductIds();
    _initUpdateStream();
    _initStore();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _paymentProviderModel = Provider.of<PaymentProviderModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _addProductIds() {
    for(int i = 0 ; i < _userProviderModel.productList.length ; i++) {
      if(Platform.isIOS) {
        _productIds.add(_userProviderModel.productList[i].iapApple);
      }else {
        _productIds.add(_userProviderModel.productList[i].iapGoogle);
      }
    }
  }

  void _initUpdateStream() {
    Stream purchaseUpdated = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      // 결제 업데이트 에러
      print("init update Stream error : ${error.toString()}");
    });
  }

  void _initStore() async {
    _isAvailable = await _connection.isAvailable();
    if(_isAvailable) {
      _getProducts();
    }
    if(Platform.isIOS) {
      var paymentWrapper = SKPaymentQueueWrapper();
      var transactions = await paymentWrapper.transactions();
      transactions.forEach((transaction) async {
        await paymentWrapper.finishTransaction(transaction);
      });
    }
  }

  Future<void> _getProducts() async {
    ProductDetailsResponse response = await _connection.queryProductDetails(_productIds.toSet());
    _products = response.productDetails;
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if(purchaseDetails.status != PurchaseStatus.pending) {
        if(purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            _isPaying = false;
          });
          scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(Strings.payment_error_canceled)));
        }else if(purchaseDetails.status == PurchaseStatus.purchased) {                //  결제 완료
          _deliverProduct(purchaseDetails.verificationData.localVerificationData);
        }
      }else {
        print("purchase pending...");
      }
      if(Platform.isAndroid) {
        if(!_autoConsume && purchaseDetails.productID == "io.com.diction.deukki.annual") {
          await InAppPurchaseConnection.instance.consumePurchase(purchaseDetails);
        }
      }
      if(purchaseDetails.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
      }
    });
  }

  void _deliverProduct(String receipt) {
    initPaymentPreRequest ??= _paymentProviderModel.value.paymentPreRequest;
    if(initPaymentPreRequest.hasData && initPaymentPreRequest.result.isValue) {
      _paymentId ??= initPaymentPreRequest.result.asValue.value;

      _paymentProviderModel.paymentValidation(_authServiceAdapter.authJWT, Platform.isIOS ? "Apple" : "Google", receipt, _paymentId).then((value) {
        final validation = _paymentProviderModel.value.paymentValidation;
        if(validation.result.asValue.value.status == 200) {
          final expiredDate = validation.result.asValue.value.result['expiredDate'];
          _userProviderModel.setPremiumPopupShow();
          _userProviderModel.setUserPremium(expiredDate);
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Strings.payment_completed), duration: Duration(seconds: 2)));
          Navigator.of(context).pop();
        }else if(validation.result.asValue.value.status == 400) {
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Strings.payment_error)));
        }else {
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Strings.payment_server_error)));
        }

        setState(() {
          _isPaying = false;
        });
      });
    }
  }

  void _paymentPreRequest(ProductionVO productionVO) {
    setState(() {
      _isPaying = true;
    });
    paymentPreRequestInit ??= _paymentProviderModel.paymentPreRequest(
        _authServiceAdapter.authJWT,
        TYPE_SUBSCRIPTION,
        productionVO.discountPrice,
        CURRENCY_KRW,
        true,
        Platform.isIOS ? "Apple" : "Google",
        true,
        14,
        productionVO.idx);
  }

  void _buyProduct(ProductDetails productDetails, bool isConsumable) {
    PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails, sandboxTesting: false);
    if(isConsumable) {
      _connection.buyConsumable(purchaseParam: purchaseParam, autoConsume: _autoConsume || Platform.isIOS);
    }else {
      _connection.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Widget _closeButtonWidget() {               //  close button
    //AnalyticsService().sendAnalyticsEvent(false, userProviderModel.userVOForHttp.premium == 0 ? false : true, PAGE_RECORD, "close", "", "");
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(24),
        child: Image.asset(AppImages.xButton, width: 24, height: 24,),
      ),
      onTap: () {
        Navigator.pop(context);
        _userProviderModel.setPremiumPopupShow();
      },
    );
  }

  Widget _contentsWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 3),
          width: deviceWidth < 750 ? deviceWidth * 0.41 : deviceWidth * 0.43,
          child: OverflowBox(
            maxWidth: deviceWidth * 0.49,
            alignment: Alignment.bottomRight,
            child: SizedBox(
              child: Image.asset(AppImages.pictureImage, height: deviceHeight * 0.97, fit: BoxFit.fitHeight),
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "NotoSansKR",
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: deviceWidth > 900 ? "${Strings.premium_popup_title}\n" : Strings.premium_popup_title,
                          style: TextStyle(color: MainColors.green_dark, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: deviceWidth > 900 ? "   ${Strings.premium_popup_name1}  " : "      ${Strings.premium_popup_name1}  ",
                          style: TextStyle(color: MainColors.grey_name, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                            text: Strings.premium_popup_name2,
                            style: TextStyle(color: MainColors.grey_dark, fontSize: 12, fontWeight: FontWeight.w400)
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      Strings.premium_popup_title2,
                      style: TextStyle(
                          color: MainColors.grey_100,
                          fontSize: deviceWidth > 900 ? 25 : 22,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: MainColors.grey_script,
                              fontSize: deviceWidth < 700 ? 15 : 16,
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.w400
                          ),
                          children: <TextSpan>[
                            TextSpan(text: "${Strings.premium_popup_script1}\n"),
                            TextSpan(text: "${Strings.premium_popup_script2}\n"),
                            TextSpan(text: "${Strings.premium_popup_script3}")
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 23),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      Strings.premium_popup_free_start,
                      style: TextStyle(
                          color: MainColors.green_100,
                          fontSize: 16,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  SizedBox(height: 9),
                  SizedBox(child: _listWidget()),
                  SizedBox(height: 22),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: MainColors.grey_dark,
                          fontSize: 13,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w400
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "${Strings.membership_guide_title}\n", style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: "${Strings.membership_guide_1}\n"),
                        TextSpan(text: "${Strings.membership_guide_2}\n"),
                        TextSpan(text: "${Strings.membership_guide_3}\n"),
                        TextSpan(text: "${Strings.membership_guide_4}\n"),
                        TextSpan(text: "${Strings.membership_guide_5}\n"),
                        TextSpan(text: "${Strings.membership_guide_6}\n\n"),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_title}\n" : "${Strings.payment_android_guide_title}\n", style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_1}\n" : "${Strings.payment_android_guide_1}\n"),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_2}\n" : "${Strings.payment_android_guide_2}\n"),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_3}\n" : "${Strings.payment_android_guide_3}\n"),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_4}\n" : "${Strings.payment_android_guide_4}\n"),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_5}\n" : "${Strings.payment_android_guide_5}\n"),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_6}\n" : "${Strings.payment_android_guide_6}\n"),
                        TextSpan(text: Platform.isIOS ? "${Strings.payment_iOS_guide_7}" : "${Strings.payment_android_guide_7}"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: deviceWidth < 750 ? 5 : 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: InkWell(
                            child: Text(
                              Strings.mypage_setting_show_terms,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: MainColors.grey_dark,
                                color: MainColors.grey_dark,
                                fontSize: 12,
                                fontFamily: "NotoSansKR",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              //AnalyticsService().sendAnalyticsEvent(false, _userProviderModel.userVOForHttp.premium == 0 ? false : true, PAGE_MY_MEMBERSHIP, "terms", "", "");
                              RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_TERMS, context);
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: InkWell(
                            child: Text(
                              Strings.mypage_setting_show_info,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: MainColors.grey_dark,
                                color: MainColors.grey_dark,
                                fontSize: 12,
                                fontFamily: "NotoSansKR",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              //AnalyticsService().sendAnalyticsEvent(false, _userProviderModel.userVOForHttp.premium == 0 ? false : true, PAGE_MY_MEMBERSHIP, "privacy", "", "");
                              RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_INFO, context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25)
                ],
              ),
            ),
          ),
        ),
        _closeButtonWidget(),
      ],
    );
  }

  Widget _listWidget() {
    return Container(
      height: deviceHeight * 0.18,
      child: ListView.builder(
        shrinkWrap: true,
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(right: 0, left: 0),
        scrollDirection: Axis.horizontal,
        itemCount: _userProviderModel.productList.length,
        itemBuilder: (BuildContext context, i) {
          return _listItemWidget(i, _userProviderModel.productList[i]);
        },
      ),
    );
  }

  Widget _listItemWidget(int index, ProductionVO productionVO) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            color: MainColors.green_dark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: MainColors.green_dark),
            ),
            elevation: 0,
            child: Container(
              width: deviceWidth * 0.23,
              height: deviceWidth < 750 ? (deviceWidth * 0.27) * 0.22 : (deviceWidth * 0.27) * 0.2,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 0,
                    left: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: deviceWidth < 750 ? 14 : 16, fontFamily: "NotoSansKR"),
                          children: <TextSpan>[
                            TextSpan(text: "${_numberWithComma(productionVO.discountPrice)}${Strings.mypage_membership_annual_won}", style: TextStyle(fontWeight: FontWeight.w700)),
                            TextSpan(text: productionVO.discountPrice > 50000 ? " / ${Strings.premium_popup_annual}" : " / ${Strings.premium_popup_monthly}", style: TextStyle(fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                    top: 0,
                    bottom: 0,
                  ),
                  Positioned(child: Icon(Icons.arrow_forward_ios, size: deviceWidth < 750 ? 13 : 15, color: Colors.white), right: deviceWidth < 750 ? 3 : 11, top: 0, bottom: 0,)
                ],
              ),
            ),
          ),
          productionVO.discountPrice > 50000
          ? Text(
            "(${Strings.premium_popup_monthly_price}${_numberWithComma(productionVO.monthlyPrice)}${Strings.mypage_membership_annual_won})",
            style: TextStyle(
              color: MainColors.grey_price,
              fontSize: 12,
              fontFamily: "NotoSansKR",
              fontWeight: FontWeight.w400
            ),
          )
          : Container(),
        ],
      ),
      onTap: () {
        //  결제
        _paymentPreRequest(productionVO);
        if(_products.firstWhere((element) => element.id == productionVO.iapGoogle, orElse: () => null) != null) {
          _buyProduct(_products.firstWhere((element) => element.id == productionVO.iapGoogle, orElse: () => null), false);
        }else {
          setState(() {
            _isPaying = false;
          });
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Strings.payment_not_found_error)));
        }
      },
    );
  }

  String _numberWithComma(int num) {
    return NumberFormat('###,###,###,###').format(num).replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: scaffoldKey,
            backgroundColor: MainColors.grey_20,
            body: SafeArea(
              left: false,
              right: false,
              bottom: false,
              top: false,
              child: Stack(
                children: <Widget>[
                  Positioned(child: _contentsWidget()),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isPaying,
            child: Container(
              color: Colors.black26,
              alignment: AlignmentDirectional.center,
              child: CupertinoActivityIndicator(radius: 14),
            ),
          )
        ],
      ),
    );
  }
}
