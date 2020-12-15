import 'dart:async';
import 'dart:io';

import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/payment/payment_provider_model.dart';
import 'package:deukki/provider/resource/mypage_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/store_kit_wrappers.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MemberShip extends StatefulWidget {
  @override
  _MemberShipState createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  UserProviderModel _userProviderModel;
  AuthServiceAdapter _authServiceAdapter;
  PaymentProviderModel _paymentProviderModel;
  MyPageProvider _myPageProvider;

  Future<void> paymentPreRequestInit;
  var initPaymentPreRequest;

  List<ProductDetails> _products = [];

  List<String> _productIds = ['io.com.diction.deukki.monthly', 'io.com.diction.deukki.annual'];

  double deviceWidth, deviceHeight;
  int _premium;
  String _paymentId, _premiumEndAt;
  bool _isAvailable = false;
  bool _autoConsume = true;


  @override
  void didChangeDependencies() {
    _authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    _userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    _paymentProviderModel = Provider.of<PaymentProviderModel>(context);
    _myPageProvider = Provider.of<MyPageProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _initUpdateStream();
    _initStore();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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

  Widget _listWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      height: deviceHeight * 0.6,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: _userProviderModel.productList.length,
        itemBuilder: (BuildContext context, i) {
          return _listItemWidget(i, _userProviderModel.productList[i]);
        },
      ),
    );
  }

  Widget _listItemWidget(int i, ProductionVO productionVO) {
    return GestureDetector(
      child: Card(
        color: i == 0 ? MainColors.green_100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: i == 0 ? MainColors.green_100 : MainColors.grey_50,
            width: 2,
          ),
        ),
        elevation: 0,
        child: Container(
          width: (deviceWidth * 0.87) / _userProviderModel.productList.length,
          height: deviceHeight * 0.6,
          padding: EdgeInsets.only(left: 16, right: 24, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                productionVO.title,
                style: TextStyle(
                  color: i == 0 ? Colors.white : MainColors.grey_100,
                  fontSize: 20,
                  fontFamily: "TmoneyRound",
                  fontWeight: FontWeight.w700
                ),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16, fontFamily: "NotoSansKR"),
                        children: <TextSpan>[
                          TextSpan(
                              text: "${_numberWithComma(productionVO.price)}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: i == 0 ? MainColors.green_30 : MainColors.grey_price,
                                  color: i == 0 ? MainColors.green_30 : MainColors.grey_price,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                          TextSpan(
                              text: "   ${productionVO.discountRate}${Strings.mypage_membership_discount_rate}",
                              style: TextStyle(
                                  color: i == 0 ? Colors.white : MainColors.grey_100,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.w900,
                              color: i == 0 ? Colors.white : MainColors.green_100
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "${_numberWithComma(productionVO.discountPrice)} ",
                                style: TextStyle(fontSize: 32)
                            ),
                            TextSpan(
                                text: i == 0 ? Strings.mypage_membership_won : Strings.mypage_membership_annual_won,
                                style: TextStyle(fontSize: 20)
                            )
                          ]
                      ),
                    ),

                    Text(
                      i == 0 ? "" : "(${Strings.mypage_membership_monthly_price} ${_numberWithComma(productionVO.monthlyPrice)}${Strings.mypage_membership_annual_won})",
                      style: TextStyle(
                        color: MainColors.grey_answer,
                        fontSize: 16,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                )
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      Strings.mypage_membership_join,
                      style: TextStyle(
                          color: i == 0 ? Colors.white : MainColors.grey_100,
                          fontSize: 16,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, size: 17, color: i == 0 ? Colors.white : MainColors.grey_100,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        //  멤버십 구매
        _paymentPreRequest(productionVO);
        if(productionVO.title.contains("월 정기")) {
          _buyProduct(_products.firstWhere((element) => element.id == "io.com.diction.deukki.monthly", orElse: () => null), false);
        }else {
          _buyProduct(_products.firstWhere((element) => element.id == "io.com.diction.deukki.annual", orElse: () => null), true);
        }
      },
    );
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

  void _paymentPreRequest(ProductionVO productionVO) {
    _myPageProvider.setIsPaying(true);
    paymentPreRequestInit ??= _paymentProviderModel.paymentPreRequest(
        _authServiceAdapter.authJWT,
        productionVO.idx == 1 ? TYPE_SUBSCRIPTION : TYPE_OFFLINE,
        productionVO.discountPrice,
        CURRENCY_KRW,
        true,
        Platform.isIOS ? "Apple" : "Google",
        productionVO.idx);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if(purchaseDetails.status != PurchaseStatus.pending) {
        if(purchaseDetails.status == PurchaseStatus.error) {
          _myPageProvider.setIsPaying(false);
          scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(Strings.payment_error_canceled)));
          print("receipt : ${purchaseDetails.verificationData.localVerificationData}");
        }else if(purchaseDetails.status == PurchaseStatus.purchased) {
          _deliverProduct();
          print("receipt : ${purchaseDetails.verificationData.localVerificationData}");
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

  void _deliverProduct() {
    //  TODO: 서버 결제 완료 api 콜, 결제 재테스트
    initPaymentPreRequest ??= _paymentProviderModel.value.paymentPreRequest;
    if(initPaymentPreRequest.hasData && initPaymentPreRequest.result.isValue) {
      _paymentId ??= initPaymentPreRequest.result.asValue.value;
      scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(Strings.payment_completed), duration: Duration(seconds: 2)));
    }
    setState(() {
      _premium = 1;
      _premiumEndAt = _dateFormat("2021-12-13");
      _userProviderModel.userVOForHttp.premium = 1;
      _myPageProvider.setIsPaying(false);
    });
  }

  void _buyProduct(ProductDetails productDetails, bool isConsumable) {
    PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails, sandboxTesting: false);
    if(isConsumable) {
      _connection.buyConsumable(purchaseParam: purchaseParam, autoConsume: _autoConsume || Platform.isIOS);
    }else {
      _connection.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void _couponRegistration() {
    RouteNavigator().go(GetRoutesName.ROUTE_COUPON_REGISTRATION, context);
  }

  String _numberWithComma(int num) {
    return NumberFormat('###,###,###,###').format(num).replaceAll(' ', '');
  }

  String _dateFormat(String date) {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("yyyy년 MM월 dd일").format(tempDate);
  }


  @override
  Widget build(BuildContext context) {

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    if(_userProviderModel.userVOForHttp != null) {
      _premium ??= _userProviderModel.userVOForHttp.premium;
      if(_userProviderModel.userVOForHttp.premiumEndAt != null) {
        _premiumEndAt ??= _dateFormat(_userProviderModel.userVOForHttp.premiumEndAt);
      }
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 60, top: 16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "${Strings.mypage_membership_status}",
                              style: TextStyle(
                                  color: MainColors.grey_100,
                                  fontSize: 24,
                                  fontFamily: "TmoneyRound",
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          SizedBox(width: 3),
                          Container(
                            child: Text(
                              _premium == 0 ? Strings.mypage_membership_status_noMember : Strings.mypage_membership_status_yesMember,
                              style: TextStyle(
                                  color: MainColors.grey_100,
                                  fontSize: 24,
                                  fontFamily: "TmoneyRound",
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 60, top: 8),
                      child: Text(
                        _premium == 0 ? Strings.mypage_membership_title : "${Strings.mypage_membership_end_at}$_premiumEndAt",  //  멤버십 만료일
                        style: TextStyle(
                            color: MainColors.grey_100,
                            fontSize: 16,
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 0),
                Platform.isAndroid ?
                Container(
                  margin: EdgeInsets.only(right: 60),
                  child: CommonRaisedButton(                    //  쿠폰 등록
                    textColor: MainColors.green_100,
                    buttonColor: Colors.white,
                    borderColor: MainColors.green_100,
                    buttonText: Strings.coupon_registration,
                    fontSize: 14,
                    voidCallback: _couponRegistration
                  ),
                ) :
                SizedBox(),
              ],
            ),
            SizedBox(height: _premium == 0 && _userProviderModel.userVOForHttp.premiumType == 4000 || _userProviderModel.userVOForHttp.premiumType == 4002 ? 22 : 0),
            //  ListView,
            _premium == 0 && _userProviderModel.userVOForHttp.premiumType == 4000 || _userProviderModel.userVOForHttp.premiumType == 4002
                ? SizedBox(child: _listWidget())
                : SizedBox(width: 0),
            SizedBox(height: 24),
            Container(
              margin: EdgeInsets.only(left: 60, right: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${Strings.membership_guide_title}",
                    style: TextStyle(color: MainColors.grey_100, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.membership_guide_1}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.membership_guide_2}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.membership_guide_3}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.membership_guide_4}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.membership_guide_5}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.membership_guide_6}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 16),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_title}" : "${Strings.payment_android_guide_title}",
                    style: TextStyle(color: MainColors.grey_100, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_1}" : "${Strings.payment_android_guide_1}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_2}" : "${Strings.payment_android_guide_2}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_3}" : "${Strings.payment_android_guide_3}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_4}" : "${Strings.payment_android_guide_4}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_5}" : "${Strings.payment_android_guide_5}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_6}" : "${Strings.payment_android_guide_6}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Platform.isIOS ? "${Strings.payment_iOS_guide_7}" : "${Strings.payment_android_guide_7}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(left: 60),
              child: Row(
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Text(
                        Strings.mypage_setting_show_terms,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: MainColors.grey_70,
                          color: MainColors.grey_70,
                          fontSize: 14,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
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
                          decorationColor: MainColors.grey_70,
                          color: MainColors.grey_70,
                          fontSize: 14,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_INFO, context);
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
