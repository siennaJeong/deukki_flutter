import 'dart:ui';

import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/payment/payment_provider_model.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deukki/common/utils/validator.dart';
import 'package:provider/provider.dart';

class CouponRegistration extends BaseWidget {
  @override
  _CouponRegistrationState createState() => _CouponRegistrationState();
}

class _CouponRegistrationState extends State<CouponRegistration> with Validator {
  static const String PAGE_COUPON = "coupon_registration";
  final _couponFormKey = GlobalKey<FormState>();
  FocusNode _focusNode;

  AuthServiceAdapter _authServiceAdapter;
  PaymentProviderModel _paymentProviderModel;
  UserProviderModel _userProviderModel;

  double deviceWidth, deviceHeight;
  String couponCode, _title = "";
  bool _isDialogVisible = false;

  @override
  void initState() {
    _authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    _paymentProviderModel = Provider.of<PaymentProviderModel>(context, listen: false);
    _userProviderModel = Provider.of<UserProviderModel>(context, listen: false);

    ///AnalyticsService().sendAnalyticsEvent(true, _userProviderModel.userVOForHttp.premium == 0 ? false : true, PAGE_COUPON, "", "", "");
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _unFocused() {
    if(_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  void _couponRegistration() {
    _unFocused();
    ///AnalyticsService().sendAnalyticsEvent(false, _userProviderModel.userVOForHttp.premium == 0 ? false : true, PAGE_COUPON, "registration", "", "");
    if(_couponFormKey.currentState.validate()) {
      _couponFormKey.currentState.save();
      //  서버 api 콜
      _paymentProviderModel.couponRegistration(_authServiceAdapter.authJWT, couponCode).then((value) {
        final status = _paymentProviderModel.value.couponRegistration;
        if(status.result.asValue.value == 200) {
          _userProviderModel.getUserInfo(_authServiceAdapter.authJWT, _authServiceAdapter);
          _title = Strings.coupon_dialog_reg_ok;
        }else if(status.result.asValue.value == 404) {
          _title = Strings.coupon_dialog_reg_fail;
        }else if(status.result.asValue.value == 409) {
          _title = Strings.coupon_dialog_reg_dup;
        }
        setState(() {
          _isDialogVisible = true;
        });
      });

    }
  }

  void _dismissDialog() {
    _unFocused();
    Navigator.of(context).pop();
  }

  Widget _dialogWidget() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9.2, sigmaY: 9.2),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
        ),
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: deviceWidth * 0.5,
            height: deviceHeight * 0.43,
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 32, bottom: 24),
                      child: Text(_title, style: Theme.of(context).textTheme.bodyText2,),
                    ),
                    Container(
                      width: (deviceWidth * 0.5) * 0.67,
                      child: CommonRaisedButton(
                        textColor: Colors.white,
                        buttonColor: MainColors.purple_100,
                        borderColor: MainColors.purple_100,
                        buttonText: Strings.common_btn_ok,
                        fontSize: 16,
                        voidCallback: _dismissDialog,
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            left: false,
            right: false,
            child: GestureDetector(
              onTap: () {
                _unFocused();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.center,
                          margin: EdgeInsets.only(top: 24, bottom: 20),
                          child: Text(
                            Strings.coupon_registration,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MainColors.grey_100,
                                fontSize: 24,
                                fontFamily: "TmoneyRound",
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        Container(                      //  X Button
                          alignment: AlignmentDirectional.centerEnd,
                          margin: EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.all(24),
                              child: Image.asset(AppImages.xButton, width: 24, height: 24,),
                            ),
                            onTap: () {
                              _unFocused();
                              ///AnalyticsService().sendAnalyticsEvent(false, _userProviderModel.userVOForHttp.premium == 0 ? false : true, PAGE_COUPON, "close", "", "");
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _couponFormKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: deviceWidth * 0.62,
                            margin: EdgeInsets.only(top: 8, left: 54),
                            child: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              style: Theme.of(context).textTheme.bodyText2,
                              focusNode: _focusNode,
                              validator: couponValidation,
                              onSaved: (String value) {
                                couponCode = value;
                              },
                              decoration: InputDecoration(
                                hintText: Strings.coupone_input_hint,
                                hintStyle: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    fontWeight: FontWeight.w400,
                                    color: MainColors.grey_text
                                ),
                                contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: MainColors.grey_border, width: 2.0)
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: Colors.red, width: 2.0)
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: Colors.red, width: 2.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 14),
                          Container(
                            width: deviceWidth * 0.2,
                            margin: EdgeInsets.only(top: 8, right: 54),
                            child: CommonRaisedButton(
                              textColor: Colors.white,
                              buttonColor: MainColors.purple_100,
                              borderColor: MainColors.purple_100,
                              buttonText: Strings.common_btn_ok,
                              fontSize: 16,
                              voidCallback: _couponRegistration,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      margin: EdgeInsets.only(left: 60, right: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${Strings.coupon_script1}",
                            style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${Strings.coupon_script2}",
                            style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isDialogVisible,
          child: _dialogWidget(),
        ),
      ],
    );
  }
}
