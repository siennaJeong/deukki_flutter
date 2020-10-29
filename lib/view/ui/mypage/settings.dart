import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:volume/volume.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AudioManager _audioManager;
  int maxVoiceVol, currentVoiceVol;
  int maxEffectVol, currentEffectVol;
  var voiceControl;

  double deviceWidth, deviceHeight;
  bool _kakaoNotification = false;

  @override
  void initState() {
    _audioManager = AudioManager.STREAM_SYSTEM;
    initVoiceState(AudioManager.STREAM_MUSIC);
    updateVoiceVolume();

    initVoiceState(AudioManager.STREAM_RING);
    updateEffectVolume();
    super.initState();
  }

  Future<void> initVoiceState(AudioManager am) async {
    await Volume.controlVolume(am);
  }


  updateVoiceVolume() async {
    print("audio manager index : " + _audioManager.index.toString());
    maxVoiceVol = await Volume.getMaxVol;
    currentVoiceVol = await Volume.getVol;
    setState(() {});
  }

  updateEffectVolume() async {
    print("audio manager index : " + _audioManager.index.toString());
    maxEffectVol = await Volume.getMaxVol;
    currentEffectVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i);
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
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsets.only(right: 8, left: 16),
                child: Image.asset(AppImages.kakaoYellowLogo, width: 24, height: 24),
              )
            ),
            Expanded(
              flex: 17,
              child: Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  "aefawergtdfgaaa@gmail.com",
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
      onTap: () { },    //  로그아웃
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
                  scale: 0.9,
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
                      "1.0.0",
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
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.volume_up,
                    color: MainColors.green_100,
                    size: 25,
                  ),
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      Strings.mypage_setting_sound,
                      style: TextStyle(
                          color: MainColors.grey_100,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    Strings.mypage_setting_voice,
                    style: TextStyle(
                      color: MainColors.grey_100,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: deviceWidth * 0.67,
                    height: 8,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Slider(
                      value: currentVoiceVol != null ? currentVoiceVol / 1.0 : 0.0 / 1.0,
                      max: maxVoiceVol != null ? maxVoiceVol / 1.0 : 0.0 / 1.0,
                      min: 0,
                      activeColor: MainColors.purple_100,
                      inactiveColor: MainColors.grey_50,
                      onChanged: (double d) {
                        setVol(d.toInt());
                        updateVoiceVolume();
                      }
                    )
                  ),
                  onTap: () {
                    print("voice tap");
                    initVoiceState(AudioManager.STREAM_MUSIC);
                    updateVoiceVolume();
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    Strings.mypage_setting_sound_effect,
                    style: TextStyle(
                        color: MainColors.grey_100,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: deviceWidth * 0.67,
                    height: 8,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Slider(
                      value: currentEffectVol != null ? currentEffectVol / 1.0 : 0.0 / 1.0,
                      max: maxEffectVol != null ? maxEffectVol / 1.0 : 0.0 / 1.0,
                      min: 0,
                      activeColor: MainColors.purple_100,
                      inactiveColor: MainColors.grey_50,
                      onChanged: (double d) {
                        setVol(d.toInt());
                        updateEffectVolume();
                      }
                    ),
                  ),
                  onTap: () {
                    print("effect tap");
                    initVoiceState(AudioManager.STREAM_RING);
                    updateEffectVolume();
                  },
                ),
              ],
            ),
          ],
        ),
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
          margin: EdgeInsets.only(top: 16),
          child: Column(
            children: <Widget>[
              _emailWidget(),
              _otherSettingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
