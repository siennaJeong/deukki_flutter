import 'dart:io';
import 'dart:ui';

import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:volume/volume.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const String PAGE_MY_SETTINGS = "MY Settings";
  AuthServiceAdapter _authServiceAdapter;
  UserProviderModel _userProviderModel;

  double deviceWidth, deviceHeight;
  bool _kakaoNotification, _clickEnable;
  int _loginMethod;
  String _email;

  PackageInfo _packageInfo;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    _userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    getPackageInfo();
    _clickEnable ??= true;

    AnalyticsService().sendAnalyticsEvent("${AnalyticsService.VISIT}$PAGE_MY_SETTINGS", null);
    super.initState();
  }

  Future<void> getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  void _setKakaoAlarm() {
    _clickEnable = false;
    if(!_kakaoNotification) {
      _authServiceAdapter.changeKakaoNoti(false);
      _userProviderModel.updateMarketingAgree(_authServiceAdapter.authJWT, AuthService.KAKAO_NOTIFICATION , false, "").then((value) {
        _clickEnable = true;
      });
    }else {
      _authServiceAdapter.changeKakaoNoti(true);
      if(_userProviderModel.userVOForHttp.loginMethod != LoginMethod.kakao) {
        _authServiceAdapter.signInWithSNS(AuthServiceType.Kakao).then((value) {
          if(value.isNotEmpty && value != "cancel") {
            _userProviderModel.updateMarketingAgree(_authServiceAdapter.authJWT, AuthService.KAKAO_NOTIFICATION , true, _authServiceAdapter.phone).then((value) {
              _clickEnable = true;
            });
          }else {
            print("kakao alarm login cancel");
            setState(() {
              _kakaoNotification = false;
            });

            _authServiceAdapter.changeKakaoNoti(false);
          }

        });
      }
    }
  }

  void _showSignOutConfirm() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return _confirmDialog(Strings.signout_confirm, true);
      }
    );
  }

  void _showSignOutAlert() {
    _userProviderModel.signOut(_authServiceAdapter.authJWT);
    _authServiceAdapter.logout();
    _dismissDialog();
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return _confirmDialog(Strings.signout_alert, false);
      }
    );
  }

  void _dismissDialog() {
    Navigator.of(context).pop();
  }

  void _exitApp() {
    _dismissDialog();
    if(Platform.isIOS) {
      RouteNavigator().go(GetRoutesName.ROUTE_LOGIN, context);
    }else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  Widget _emailWidget() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: MainColors.grey_30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.only(right: 8, left: 16),
                child: _snsLogo(_loginMethod),
              )
            ),
            Expanded(
              flex: 17,
              child: Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                 _email,
                  style: TextStyle(
                      color: MainColors.grey_100,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: _logoutButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget _snsLogo(int loginMethod) {
    String img;
    Color color;
    switch(loginMethod) {
      case LoginMethod.facebook:
        img = AppImages.facebookLogo;
        color = MainColors.blue_facebook;
        break;
      case LoginMethod.google:
        img = AppImages.googleLogo;
        color = MainColors.grey_google;
        break;
      case LoginMethod.apple:
        img = AppImages.appleLogo;
        color = Colors.black;
        break;
      case LoginMethod.kakao:
        img = AppImages.kakaoYellowLogo;
        color = MainColors.grey_30;
        break;
      case LoginMethod.unknown:
        break;
    }
    return SizedBox(
      width: 24,
      height: 24,
      child: Container(
        padding: EdgeInsets.all(loginMethod == LoginMethod.kakao ? 0 : 4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          img,
          width: loginMethod == LoginMethod.kakao ? 24 : 14,
          height: loginMethod == LoginMethod.kakao ? 24 : 14,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 24, left: 16),
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          Strings.logout,
          style: TextStyle(
            color: MainColors.grey_80,
            fontFamily: "NotoSansKR",
            fontWeight: FontWeight.w400,
            fontSize: 16
          ),
        ),
      ),
      onTap: () {
        AnalyticsService().sendAnalyticsEvent("MYS Logout", null);
        _authServiceAdapter.logout();                             //  Firebase 로그아웃
        _userProviderModel.logout(_authServiceAdapter.authJWT);   //  서버 로그아웃
        RouteNavigator().go(GetRoutesName.ROUTE_LOGIN, context);
      },
    );
  }

  Widget _updateButton() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 2),
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          Strings.mypage_setting_update,
          style: TextStyle(
              color: MainColors.grey_80,
              fontFamily: "NotoSansKR",
              fontWeight: FontWeight.w400,
              fontSize: 16
          ),
        ),
      ),
    );
  }

  Widget _otherSettingWidget() {
    return Card(
      color: MainColors.grey_30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(top: 24, bottom: 24, left: 20, right: 24),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.notifications,
                    color: MainColors.green_100,
                    size: 25,
                  ),
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      Strings.mypage_setting_kakao_alert,
                      style: TextStyle(
                          color: MainColors.grey_100,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(                         //  카카오톡 학습 알림
                    activeColor: MainColors.purple_100,
                    value: _kakaoNotification,
                    onChanged: (value) {
                      setState(() {
                        if(_clickEnable) {
                          AnalyticsService().sendAnalyticsEvent("MYS Alert", <String, dynamic> {'enable': value});
                          _kakaoNotification = value;
                          _setKakaoAlarm();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.check_circle,
                    color: MainColors.green_100,
                    size: 25,
                  ),
                ),
                SizedBox(width: 13),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    Strings.mypage_setting_version,
                    style: TextStyle(
                        color: MainColors.grey_100,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    child: Text(
                      _packageInfo != null ? _packageInfo.version : "",
                      style: TextStyle(
                        color: MainColors.grey_100,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                //_updateButton()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showTerms() {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 20, right: 20),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: InkWell(
                  child: Text(
                    Strings.mypage_setting_show_terms,
                    style: TextStyle(
                        color: MainColors.grey_80,
                        fontSize: 16,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  onTap: () {
                    AnalyticsService().sendAnalyticsEvent("MYS Terms", null);
                    RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_TERMS, context);
                  },
                ),
              ),
              SizedBox(width: 40),
              Container(
                child: InkWell(
                  child: Text(
                    Strings.mypage_setting_show_info,
                    style: TextStyle(
                        color: MainColors.grey_80,
                        fontSize: 16,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  onTap: () {
                    AnalyticsService().sendAnalyticsEvent("MYS Privacy", null);
                    RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_INFO, context);
                  },
                ),
              )
            ],
          ),
          Positioned(
            right: 0,
            child: Container(
              child: InkWell(
                child: Text(
                  Strings.signout,
                  style: TextStyle(
                    color: MainColors.grey_80,
                    fontSize: 16,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  AnalyticsService().sendAnalyticsEvent("MYS Sign out", null);
                  _showSignOutConfirm();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmDialog(String title, bool isConfirm) {
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
            width: deviceWidth * 0.6,
            height: !isConfirm ? deviceHeight * 0.43 : deviceHeight * 0.64,
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 32, bottom: 30, left: 60, right: 60),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        !isConfirm ?
                        SizedBox() :
                        Container(
                          width: (deviceWidth * 0.6) * 0.38,
                          child: CommonRaisedButton(
                            textColor: MainColors.purple_100,
                            buttonColor: Colors.white,
                            borderColor: MainColors.purple_100,
                            buttonText: Strings.common_btn_yes,
                            fontSize: 16,
                            voidCallback: _showSignOutAlert,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: !isConfirm ? (deviceWidth * 0.6) * 0.56 : (deviceWidth * 0.6) * 0.38,
                          child: CommonRaisedButton(
                            textColor: Colors.white,
                            buttonColor: MainColors.purple_100,
                            borderColor: MainColors.purple_100,
                            buttonText: !isConfirm ? Strings.common_btn_ok : Strings.common_btn_no,
                            fontSize: 16,
                            voidCallback: !isConfirm ? _exitApp : _dismissDialog,
                          ),
                        ),
                      ],
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
    KakaoContext.clientId = KAKAO_APP_KEY;
    KakaoContext.javascriptClientId = KAKAO_JS_KEY;

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    if(_authServiceAdapter.kakaoNoti.isNotEmpty) {
      _kakaoNotification ??= _authServiceAdapter.kakaoNoti == "true" ? true : false;
    }else {
      _kakaoNotification ??= _userProviderModel.userVOForHttp.loginMethod == LoginMethod.kakao ? true : false;
    }

    if(_userProviderModel.userVOForHttp != null) {
      _loginMethod = _userProviderModel.userVOForHttp.loginMethod;
      _email = _userProviderModel.userVOForHttp.email;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 16, right: 40, left: 40),
          child: Column(
            children: <Widget>[
              _emailWidget(),
              _otherSettingWidget(),
              _showTerms(),
            ],
          ),
        ),
      ),
    );
  }
}
