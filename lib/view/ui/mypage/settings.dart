import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:volume/volume.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AuthServiceAdapter _authServiceAdapter;
  UserProviderModel _userProviderModel;

  AudioManager _audioManager;
  int maxVoiceVol, currentVoiceVol;
  int maxEffectVol, currentEffectVol;
  var voiceControl;

  double deviceWidth, deviceHeight;
  bool _kakaoNotification = false;

  PackageInfo _packageInfo;

  @override
  void didChangeDependencies() {
    _authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    _userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  Future<void> getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
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
                child: _snsLogo(_userProviderModel.userVOForHttp.loginMethod),
              )
            ),
            Expanded(
              flex: 17,
              child: Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                 _userProviderModel.userVOForHttp.email,
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
                  child: CupertinoSwitch(
                    activeColor: MainColors.purple_100,
                    value: _kakaoNotification,
                    onChanged: (value) {
                      setState(() {
                        _kakaoNotification = value;
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
                _updateButton()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showTerms() {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 20),
      child: Row(
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
                RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_INFO, context);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

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
